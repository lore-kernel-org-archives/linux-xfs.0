Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6CF557F5D
	for <xfs@oss.sgi.com>; Fri, 19 Jun 2015 14:37:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3B1E18F8033
	for <xfs@oss.sgi.com>; Fri, 19 Jun 2015 12:37:57 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 3XFpAaGNaPHf2xE8 for <xfs@oss.sgi.com>;
	Fri, 19 Jun 2015 12:37:55 -0700 (PDT)
Message-ID: <55846F92.3080500@sandeen.net>
Date: Fri, 19 Jun 2015 14:37:54 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS crashes on VMs
References: <CABppvi4FZKTsu22uk6nOSaShJOUyWg7cO6h-i4YekF4MLKH8RQ@mail.gmail.com>	<8BF495B8-F444-415A-B7BF-5E1961C75817@sandeen.net>	<CABppvi5ODWyjMw0pouAQ__SQ-aGb48PEyTCPU7Dt65Z1DhKmVA@mail.gmail.com>	<556666B2.8060301@sandeen.net>	<54A83597-7AE8-4846-944F-EEE7E2AD8B3C@sandeen.net>	<CABppvi58MHbtmhx226yM+e1ntR+bPvLqk6h80guW=2cimCzSxg@mail.gmail.com>
	<CABppvi74JGacRjKpeKoJesunMo669GGVcLqg7A0WpN-yOD0mcw@mail.gmail.com>
In-Reply-To: <CABppvi74JGacRjKpeKoJesunMo669GGVcLqg7A0WpN-yOD0mcw@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Shrinand Javadekar <shrinand@maginatics.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 6/19/15 1:34 PM, Shrinand Javadekar wrote:
> I hit this problem again and captured the output of all the steps
> while repairing the filesystem. Here's the crash:
> http://pastie.org/private/prift1xjcc38s0jcvehvew

that starts with:

Jun 18 18:40:19 foods-12 kernel: [3639696.006884] ffff8801740f8000: 00 00 00 00 00 00 00 00 fb ee 00 00 00 00 00 00  ................
Jun 18 18:40:19 foods-12 kernel: [3639696.007056] ffff8801740f8010: 10 00 00 00 00 20 0f e0 00 00 00 00 00 00 00 00  ..... ..........
Jun 18 18:40:19 foods-12 kernel: [3639696.007140] ffff8801740f8020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Jun 18 18:40:19 foods-12 kernel: [3639696.007230] ffff8801740f8030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................

I think there should have been other interesting bits prior to that line, can you check, and provide it please?  Full dmesg in a pastebin would be just fine.

xfs_attr3_leaf_write_verify at line 216 of file /build/buildd/linux-lts-trusty-3.13.0/fs/xfs/xfs_attr_leaf.c.  Caller 0xffffffffa00a193a

which is ... interesting; something went wrong on the way _to_ disk?

Ok, what is wrong, then.  here's the first 64 bytes of the buffer,
it contains:

typedef struct xfs_attr_leafblock {
        xfs_attr_leaf_hdr_t     hdr;    /* constant-structure header block */

where

typedef struct xfs_attr_leaf_hdr {      /* constant-structure header block */
        xfs_da_blkinfo_t info;          /* block type, links, etc. */
        __be16  count;                  /* count of active leaf_entry's */
        __be16  usedbytes;              /* num bytes of names/values stored */
        __be16  firstused;              /* first used byte in name area */
        __u8    holes;                  /* != 0 if blk needs compaction */
        __u8    pad1;
        xfs_attr_leaf_map_t freemap[XFS_ATTR_LEAF_MAPSIZE];
                                        /* N largest free regions */
} xfs_attr_leaf_hdr_t;

and

typedef struct xfs_da_blkinfo {
        __be32          forw;                   /* previous block in list */
        __be32          back;                   /* following block in list */
        __be16          magic;                  /* validity check on block */
        __be16          pad;                    /* unused */
} xfs_da_blkinfo_t;

so:

00 00 00 00 00 00 00 00 fb ee 00 00 00 00 00 00
|   forw   |    back   |magic| pad |count|used|
10 00 00 00 00 20 0f e0 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

and the only thing the verifier checks on non-crc is
magic (which is good), and count (which is what tripped here)

        if (xfs_sb_version_hascrc(&mp->m_sb)) {
		<snip>
        } else {
                if (ichdr.magic != XFS_ATTR_LEAF_MAGIC)
                        return false;
        }
        if (ichdr.count == 0)
                return false;

so this failed to verify because count was 0.

> And the output of the xfs_repair steps (also attached if needed):
> http://pastie.org/private/gvq3aiisudfhy69ezagw

Ok, no on-disk corruption, that's good.

Can you please provide as much info as possible about your system
and setup?

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

-Eric

> Hope this can provide some insights.
> 
> -Shri

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
