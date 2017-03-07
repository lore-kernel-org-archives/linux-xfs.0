Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:41964 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750796AbdCHFGw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 8 Mar 2017 00:06:52 -0500
Subject: Re: [PowerPC] XFS : Metadata corruption detected at
 0x60000000382100b0, xfs_agf block
References: <1488531850.5962.22.camel@abdul-ThinkPad-T450>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <0db2060c-2d4b-671a-47a9-01cc742c3862@sandeen.net>
Date: Tue, 7 Mar 2017 14:44:07 -0600
MIME-Version: 1.0
In-Reply-To: <1488531850.5962.22.camel@abdul-ThinkPad-T450>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Abdul Haleem <abdhalee@linux.vnet.ibm.com>, linux-xfs@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org, sachinp@linux.vnet.ibm.com, mpe@ellerman.id, aneesh.kumar@linux.vnet.ibm.com

On 3/3/17 3:04 AM, Abdul Haleem wrote:
> Hi,
> 
> Reboot fails for PowerPC machine running RHEL7.3 (3.10.0-514.el7)
> following these messages:

Generally it's best to report RHEL bugs to Red Hat.
 
> SGI XFS with ACLs, security attributes, no debug enabled
> XFS (dm-0): Mounting V5 Filesystem
> FS (dm-0): Starting recovery (logdev: internal)
> XFS (dm-0): Metadata corruption detected at 0x60000000382100b0, xfs_agf
> block 0x4b00001
> XFS (dm-0): Unmount and run xfs_repair
> XFS (dm-0): First 64 bytes of corrupted metadata buffer:
> c0000000f06b7200: 58 41 47 46 00 00 00 01 00 00 00 03 00 32 00 00 XAGF.........2..
> c0000000f06b7210: 00 00 00 01 00 00 00 02 00 00 00 00 00 00 00 01  ................
> c0000000f06b7220: 00 00 00 01 00 00 00 00 00 00 00 76 00 00 00 02  ...........v....
> c0000000f06b7230: 00 00 00 04 00 2d 0c c7 00 2a 14 62 00 00 00 00  .....-...*.b....
> XFS (dm-0): metadata I/O error: block 0x4b00001
> ("xfs_trans_read_buf_map") error 117 numblks 1
> Failed to mount /sysroot.
> 
> Steps to recreate:
> Run some file system test (ltp or xfs/086) on 4.10.0 upstream kernel
> built on the PowerVM LPAR after the test completes, reboot the machine
> back to base kernel, boot falls to dracut mode with above messages,
> every time it requires a xfs_repair to recover the file system.

... though Red Hat might tell you that running upstream kernels is
out of the supported realm.

However, this probably has to do with AGF packing changes.

> c0000000f06b7200: 58 41 47 46 00 00 00 01 00 00 00 03 00 32 00 00 XAGF.........2..
                    magic       version     sequence    length
> c0000000f06b7210: 00 00 00 01 00 00 00 02 00 00 00 00 00 00 00 01  ................
                    agf roots                           agf levels
> c0000000f06b7220: 00 00 00 01 00 00 00 00 00 00 00 76 00 00 00 02  ...........v....
                                            flfirst     fllast      
> c0000000f06b7230: 00 00 00 04 00 2d 0c c7 00 2a 14 62 00 00 00 00  .....-...*.b....
                    flcount     freeblocks  longest     btreeblks

The AGF verifier does:

        if (!(agf->agf_magicnum == cpu_to_be32(XFS_AGF_MAGIC) &&
              XFS_AGF_GOOD_VERSION(be32_to_cpu(agf->agf_versionnum)) &&
              be32_to_cpu(agf->agf_freeblks) <= be32_to_cpu(agf->agf_length) &&
              be32_to_cpu(agf->agf_flfirst) < XFS_AGFL_SIZE(mp) &&
              be32_to_cpu(agf->agf_fllast) < XFS_AGFL_SIZE(mp) &&
              be32_to_cpu(agf->agf_flcount) <= XFS_AGFL_SIZE(mp)))
                return false;

where:

#define XFS_AGFL_SIZE(mp) \
        (((mp)->m_sb.sb_sectsize - \
         (xfs_sb_version_hascrc(&((mp)->m_sb)) ? \
                sizeof(struct xfs_agfl) : 0)) / \
          sizeof(xfs_agblock_t))

and "struct xfs_agfl" packing has changed between rhel7 and upstream,
due to an early bug related to nailing down that on-disk format :/

Presumably this is what xfs_repair found and fixed?

-Eric
