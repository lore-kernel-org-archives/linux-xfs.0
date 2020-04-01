Return-Path: <SRS0=BKGZ=5R=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDAC3C43331
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Apr 2020 04:45:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 94B7720787
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Apr 2020 04:45:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="D3f/2242"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727918AbgDAEpi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Apr 2020 00:45:38 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:51566 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727727AbgDAEph (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Apr 2020 00:45:37 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0314dh6u006195;
        Wed, 1 Apr 2020 04:45:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=YdM67ldAhHFfeDw9nUHOdcdwI+KPiQC/GZZKaa1lFK0=;
 b=D3f/2242QKG9Hze6Cr9Y+7RFEJN9Bxy2wSUpcvnmNP+Wjpk21qmAQdlKpCXW8VoVyhGr
 8DmSFRkv3jR/0FCpo83ElEnYVBSvHEpkpTIebUi+DI1NOaM7kgtbR7fShtbqZvBkb3DY
 5pRifF4g19pEk9zD0LLq/tcjOH+DmkXeMe5HtfqYqr/Ggegzs1WzbLMuiHe/IVcm+XuH
 39rta1TEzjJUpGzhcel7/Fp2ZGYe0R/WP5Uk0CsBsieaKk7jKELWDzztQ2LlcueWU+Tq
 c+6+9sQ9Y7+0jRRfYS2Qkp2QuFe07OwDX+u3D+OirN2RcBd57WA/Vr78WAgKDGBDLoiJ xg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 303yun5s11-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Apr 2020 04:45:31 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0314h1kR190293;
        Wed, 1 Apr 2020 04:45:31 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 302gcepp85-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Apr 2020 04:45:31 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0314jUxN016795;
        Wed, 1 Apr 2020 04:45:30 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Mar 2020 21:45:29 -0700
Date:   Tue, 31 Mar 2020 21:45:28 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Qian Cai <cai@lca.pw>
Cc:     Chandan Rajendra <chandan@linux.ibm.com>,
        Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: xfs metadata corruption since 30 March
Message-ID: <20200401044528.GE56958@magnolia>
References: <990EDC4E-1A4E-4AC3-84D9-078ACF5EB9CC@lca.pw>
 <11749734.KdfBBZeIvc@localhost.localdomain>
 <FDCFF269-C30C-42A8-B926-A8731E110848@lca.pw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <FDCFF269-C30C-42A8-B926-A8731E110848@lca.pw>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9577 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 adultscore=0 suspectscore=27 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004010041
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9577 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 lowpriorityscore=0
 malwarescore=0 adultscore=0 priorityscore=1501 mlxlogscore=999 bulkscore=0
 suspectscore=27 mlxscore=0 spamscore=0 impostorscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004010040
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 01, 2020 at 12:15:32AM -0400, Qian Cai wrote:
> 
> 
> > On Apr 1, 2020, at 12:14 AM, Chandan Rajendra <chandan@linux.ibm.com> wrote:
> > 
> > On Wednesday, April 1, 2020 3:27 AM Qian Cai wrote: 
> >> Ever since two days ago, linux-next starts to trigger xfs metadata corruption
> >> during compilation workloads on both powerpc and arm64,
> > 
> > Can you please provide the filesystem geometry information?
> > You can get that by executing "xfs_info <mount-point>" command.
> > 

Hmm.   Do the arm/ppc systems have 64k pages?  kconfigs might be a good
starting place.  Also, does the xfs for-next branch exhibit this
problem, or is it just the big -next branch that Stephen Rothwell puts
out?

--D

> == arm64 ==
> # xfs_info /home/
> meta-data=/dev/mapper/rhel_hpe--apollo--cn99xx--11-home isize=512    agcount=4, agsize=113568256 blks
>          =                       sectsz=4096  attr=2, projid32bit=1
>          =                       crc=1        finobt=1, sparse=1, rmapbt=0
>          =                       reflink=1
> data     =                       bsize=4096   blocks=454273024, imaxpct=5
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
> log      =internal log           bsize=4096   blocks=221813, version=2
>          =                       sectsz=4096  sunit=1 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> 
> == powerpc ==
> # xfs_info /home/
> meta-data=/dev/mapper/rhel_ibm--p9wr--01-home isize=512    agcount=4, agsize=118489856 blks
>          =                       sectsz=4096  attr=2, projid32bit=1
>          =                       crc=1        finobt=1, sparse=1, rmapbt=0
>          =                       reflink=1
> data     =                       bsize=4096   blocks=473959424, imaxpct=5
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
> log      =internal log           bsize=4096   blocks=231425, version=2
>          =                       sectsz=4096  sunit=1 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> == x86 (not yet reproduced)  ==
> meta-data=/dev/mapper/rhel_hpe--dl380gen9--01-home isize=512    agcount=16, agsize=3283776 blks
>          =                       sectsz=512   attr=2, projid32bit=1
>          =                       crc=1        finobt=1, sparse=1, rmapbt=0
>          =                       reflink=1
> data     =                       bsize=4096   blocks=52540416, imaxpct=25
>          =                       sunit=64     swidth=64 blks
> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
> log      =internal log           bsize=4096   blocks=25664, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
