Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1JL0Ko0026708 for <xfs@oss.sgi.com>; Sun, 19 Feb 2012 15:00:20 -0600
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id S8OgDMhfrMXNd8tk for <xfs@oss.sgi.com>;
	Sun, 19 Feb 2012 13:00:17 -0800 (PST)
Message-ID: <4F4162DF.4000907@sandeen.net>
Date: Sun, 19 Feb 2012 15:00:15 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS memory recomendation?
References: <2BF070A7A2375D46BA1B6087F8D5DCB68BEA721CA3@seldmbx01.corpusers.net>
	<4F3F05D4.1020705@hardwarefreak.com>
	<4F3F0A4A.7050708@redhat.com> <5722408.cXkY2gHLh8@saturn>
In-Reply-To: <5722408.cXkY2gHLh8@saturn>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: Eric Sandeen <sandeen@redhat.com>, "Assarsson,
	Emil" <Emil.Assarsson@sonyericsson.com>, stan@hardwarefreak.com, xfs@oss.sgi.com

On 2/19/12 7:16 AM, Michael Monnerie wrote:
> Am Freitag, 17. Februar 2012, 18:17:46 schrieb Eric Sandeen:
>> http://xfs.org/index.php/XFS_FAQ#Q:_Which_factors_influence_the_memory
>> _usage_of_xfs_repair.3F
> 
> I tried that, and it said "use 434":

That's megabytes, FWIW.

> xfs_repair -n -vv -m 1 /dev/mapper/vg_orion-lv_orion_data 
> Phase 1 - find and verify superblock...
>         - max_mem = 1024, icount = 339648, imem = 1326, dblock = 
> 805304256, dmem = 393214
> Required memory for repair is greater that the maximum specified with 
> the -m option. Please increase it to at least 434.
> 
> But when I tried with 
> # xfs_repair -n -vv -m 434 /dev/mapper/vg_orion-lv_orion_data 
> it said the same again. It only worked with 435:
> # xfs_repair -n -vv -m 435 /dev/mapper/vg_orion-lv_orion_data 
> (is that what you call an off-by-1 error?)

Yep, but really not too serious, I guess, still worth fixing though.

It's only used to try to enforce the bare minimum - in reality you'd
want more than that.

> Maybe that has been fixed already? This is
> # xfs_repair -V
> xfs_repair Version 3.1.6
> 
> BTW, this XFS is 3219644160 KB (3,2TB), used 2,9TB, has (df -i) 325364 
> inodes used, 293884 files in 31643 dirs. It seems mem usage primarily 
> comes from inodes, not from the size of the filesystem.

        _("        - max_mem = %lu, icount = %" PRIu64 ", imem = %" PRIu64 ", db
lock = %" PRIu64 ", dmem = %" PRIu64 "\n"),
                                max_mem, mp->m_sb.sb_icount,
                                mp->m_sb.sb_icount >> (10 - 2),
                                mp->m_sb.sb_dblocks,
                                mp->m_sb.sb_dblocks >> (10 + 1));

so yes, inodes in use count for more in the approximation.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
