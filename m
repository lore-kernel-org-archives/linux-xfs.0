Return-Path: <SRS0=V6/9=Y5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BFE1CA9EC9
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Nov 2019 00:03:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 11A7320717
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Nov 2019 00:03:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VKXDYJqj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729614AbfKEADp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Nov 2019 19:03:45 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:39932 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728234AbfKEADp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Nov 2019 19:03:45 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA4NxUZu098793;
        Tue, 5 Nov 2019 00:03:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=3loFoh/e0D/nu/XadVVLFT1UOwZcOKmB+jqfY997Ynk=;
 b=VKXDYJqj+azspr16fYaYWjn6ltZGEgy3ohiTPIMzfTDHQFnvxuMbk1XAyDFleL5zHLQG
 vh6+sl7EouDr5i98mqVVRZs2wvxG6j9vAwV+9eZ8AFhZzhnlzwFpAfUC4r+hLiaLsqUU
 hGpTI2Bn5wbvdVr1IrZtNFuTRUX980wSEujW43Y5I7dsD1wEnrHJzfSPntr1QtvWDH9k
 NCk9Xz7Fq2HDpARoLrON8yvUsDmU16xKHng4qPhzGDY2sKJ28vxtjaumYa5z0JVkPsps
 kFtlT55DCDQcRvhNcS8CT+dwsUcnr5a6IGORFa4zVrGC6h1xq/Gglz0lgEi+s1VNTwz0 ZA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2w117tttjw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Nov 2019 00:03:41 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA4NwsLS025882;
        Tue, 5 Nov 2019 00:01:41 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2w1kxe6p2y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Nov 2019 00:01:41 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA501das009685;
        Tue, 5 Nov 2019 00:01:40 GMT
Received: from localhost (/10.159.233.45)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 Nov 2019 16:01:39 -0800
Date:   Mon, 4 Nov 2019 16:01:38 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Chris Holcombe <cholcombe@box.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: XFS: possible memory allocation deadlock in kmem_alloc
Message-ID: <20191105000138.GT4153244@magnolia>
References: <CAL3_v4PZLtb4hVWksWR_tkia+A6rjeR2Xc3H-buCp7pMySxE2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL3_v4PZLtb4hVWksWR_tkia+A6rjeR2Xc3H-buCp7pMySxE2Q@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9431 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911040229
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9431 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911040229
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 04, 2019 at 03:38:12PM -0800, Chris Holcombe wrote:
> After upgrading from scientific linux 6 -> centos 7 i'm starting to
> see a sharp uptick in dmesg lines about xfs having a possible memory
> allocation deadlock.  All the searching I did through previous mailing
> list archives and blog posts show all pointing to large files having
> too many extents.
> I don't think that is the case with these servers so I'm reaching out
> in the hopes of getting an answer to what is going on.  The largest
> file sizes I can find on the servers are roughly 15GB with maybe 9
> extents total.  The vast majority small with only a few extents.
> I've setup a cron job to drop the cache every 5 minutes which is
> helping but not eliminating the problem.  These servers are dedicated
> to storing data that is written through nginx webdav.  AFAIK nginx
> webdav put does not use sparse files.
> 
> Some info about the servers this issue is occurring on:
> 
> nginx is writing to 82TB filesystems:
>  xfs_info /dev/sdb1
> meta-data=/dev/sdb1              isize=512    agcount=82, agsize=268435424 blks
>          =                       sectsz=4096  attr=2, projid32bit=1
>          =                       crc=1        finobt=0 spinodes=0
> data     =                       bsize=4096   blocks=21973302784, imaxpct=1
>          =                       sunit=16     swidth=144 blks
> naming   =version 2              bsize=65536  ascii-ci=0 ftype=1
> log      =internal               bsize=4096   blocks=521728, version=2
>          =                       sectsz=4096  sunit=1 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> xfs_db -r /dev/sdb1
> xfs_db> frag
> actual 6565, ideal 5996, fragmentation factor 8.67%
> Note, this number is largely meaningless.
> Files on this filesystem average 1.09 extents per file
> 
> I see dmesg lines with various size numbers in the line:
> [6262080.803537] XFS: nginx(2514) possible memory allocation deadlock
> size 50184 in kmem_alloc (mode:0x250)

Full kernel logs, please.  There's not enough info here to tell what's
trying to grab a 50K memory buffer.

--D

> Typical extents for the largest files on the filesystem are:
> 
> find /mnt/jbod/ -type f -size +15G -printf '%s %p\n' -exec xfs_bmap
> -vp {} \; | tee extents
> 17093242444 /mnt/jbod/boxfiler3038-sdb1/data/220190411/ephemeral/2019-08-12/18/0f6bee4d6ee0136af3b58eef611e2586.enc
> /mnt/jbod/boxfiler3038-sdb1/data/220190411/ephemeral/2019-08-12/18/0f6bee4d6ee0136af3b58eef611e2586.enc:
>  EXT: FILE-OFFSET           BLOCK-RANGE              AG AG-OFFSET
>            TOTAL FLAGS
>    0: [0..1919]:            51660187008..51660188927 24
> (120585600..120587519)     1920 00010
>    1: [1920..8063]:         51660189056..51660195199 24
> (120587648..120593791)     6144 00011
>    2: [8064..4194175]:      51660210816..51664396927 24
> (120609408..124795519)  4186112 00001
>    3: [4194176..11552759]:  51664560768..51671919351 24
> (124959360..132317943)  7358584 00101
>    4: [11552760..33385239]: 51678355840..51700188319 24
> (138754432..160586911) 21832480 00111
> 
> 
> Memory size:
>  free -m
>               total        used        free      shared  buff/cache   available
> Mem:          64150        6338         421           2       57390       57123
> Swap:          2047           6        2041
> 
> cat /etc/redhat-release
> CentOS Linux release 7.6.1810 (Core)
> 
> cat /proc/buddyinfo
> Node 0, zone      DMA      0      0      1      0      1      0      0
>      0      0      1      3
> Node 0, zone    DMA32  31577     88      2      0      0      0      0
>      0      0      0      0
> Node 0, zone   Normal  33331   3323    582     87      0      0      0
>      0      0      0      0
> Node 1, zone   Normal  51121   6343    822     77      1      0      0
>      0      0      0      0
> 
> tuned-adm shows 'balanced' as the current tuning profile.
> 
> Thanks for your help!
