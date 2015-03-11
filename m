Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3A81D7F47
	for <xfs@oss.sgi.com>; Wed, 11 Mar 2015 10:46:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 27E348F8071
	for <xfs@oss.sgi.com>; Wed, 11 Mar 2015 08:46:54 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id khdbVYlYf4JAbTtc for <xfs@oss.sgi.com>;
	Wed, 11 Mar 2015 08:46:52 -0700 (PDT)
Message-ID: <5500636A.3020309@sandeen.net>
Date: Wed, 11 Mar 2015 11:46:50 -0400
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_repair: junk last entry in sf dir if name starts
	beyond dir size
References: <54FDFEDC.5090106@sandeen.net>	<1061986380.422955.1426008424991.JavaMail.zimbra@rvx.is>	<54FF2BBF.7060404@sandeen.net>	<410959445.428221.1426083973347.JavaMail.zimbra@rvx.is>	<550054D9.3010602@sandeen.net>
	<1908077521.428877.1426086242030.JavaMail.zimbra@rvx.is>
In-Reply-To: <1908077521.428877.1426086242030.JavaMail.zimbra@rvx.is>
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
To: Rui Gomes <rgomes@rvx.is>
Cc: omar <omar@rvx.is>, xfs <xfs@oss.sgi.com>

On 3/11/15 11:04 AM, Rui Gomes wrote:
> Program received signal SIGSEGV, Segmentation fault.
> 0x000000000044dbcd in __xfs_dir3_data_check (dp=dp@entry=0x0, bp=bp@entry=0x1538e810) at xfs_dir2_data.c:148
> 148                             for (i = 0; i < be32_to_cpu(btp->count); i++) {
> (gdb) bt
> #0  0x000000000044dbcd in __xfs_dir3_data_check (dp=dp@entry=0x0, bp=bp@entry=0x1538e810) at xfs_dir2_data.c:148
> #1  0x000000000044b9ea in xfs_dir3_block_verify (bp=bp@entry=0x1538e810) at xfs_dir2_block.c:62

Can you do a little digging around in gdb to sort out more
about why it segfaulted?

We got a xfs_dir2_data_hdr_t from the passed-in bp w/ valid magic:

hdr = bp->b_addr;

and from that got btp:

        switch (hdr->magic) {
        case cpu_to_be32(XFS_DIR2_BLOCK_MAGIC):
                btp = xfs_dir2_block_tail_p(mp, hdr);

and this just finds an offset from hdr:

                ((char *)hdr + mp->m_dirblksize)) - 1;

but then apparently blew up when we tried to use btp:

for (i = 0; i < be32_to_cpu(btp->count); i++) {

I don't see offhand how the hdr is ok, with good magic, but an
offset from the hdr (btp) is causing a segfault.  Can you dig around
a bit more in gdb?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
