Return-Path: <SRS0=9ni0=3C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1902C33CA9
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Jan 2020 16:53:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ABE4C207FD
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Jan 2020 16:53:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="U64IGnrD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727222AbgAMQxq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Jan 2020 11:53:46 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:54008 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726567AbgAMQxq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Jan 2020 11:53:46 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00DGpgiF086622;
        Mon, 13 Jan 2020 16:53:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=iyHoOYQJXRm2nc2tsbiEPWTnmg9sCwdjazYykxMxbxA=;
 b=U64IGnrDZxCF0hhAG8fvWgLWQyCNiauXxEzEumRJV1RhXeA7oXLJqI+ZuylZfzg8YDJd
 X9wjOhxxyHHKpI7NDmtWQE3DPBEg8C/h0G49vwFg5ghZsbnjYorfZ/VaxQS4dfuax/oM
 N6UNiZhjP461Y85jeEoKIyrv3QT9rvQgiWt+6i8j5rQM1AznktiUqph8oXBw2gh8wzzp
 q98/rrzzz3fmoDwf21hv0eQdhXdqJ+5YAsPWA8qMzqoAV9BYrhCwL/3FB/ind5E/29pr
 tpsuI8YcPAsCPhML+tlskuydqOcaGuBAXLL7z3sEZ8rWaa4A2UMGyFVqAu57flUeN4NL Iw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2xf73y87uy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Jan 2020 16:53:42 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00DGpcp8154923;
        Mon, 13 Jan 2020 16:53:42 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2xfqu4ugpg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Jan 2020 16:53:42 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00DGreC8016940;
        Mon, 13 Jan 2020 16:53:40 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 Jan 2020 08:53:40 -0800
Date:   Mon, 13 Jan 2020 08:53:41 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Gionatan Danti <g.danti@assyoma.it>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: XFS reflink vs ThinLVM
Message-ID: <20200113165341.GE8247@magnolia>
References: <fe697fb6-cef6-2e06-de77-3530700852da@assyoma.it>
 <20200113111025.liaargk3sf4wbngr@orion>
 <703a6c17-cc02-2c2c-31ce-6cd12a888743@assyoma.it>
 <20200113114356.midcgudwxpze3xfw@orion>
 <627cb07f-9433-ddfd-37d7-27efedd89727@assyoma.it>
 <39b50e2c-cb78-3bcd-0130-defa9c573b71@assyoma.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <39b50e2c-cb78-3bcd-0130-defa9c573b71@assyoma.it>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9499 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001130140
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9499 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001130140
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 13, 2020 at 04:34:50PM +0100, Gionatan Danti wrote:
> On 13/01/20 13:21, Gionatan Danti wrote:
> > On 13/01/20 12:43, Carlos Maiolino wrote:
> > > I should have mentioned it, my apologies.
> > > 
> > > 'extsize' argument for mkfs.xfs will set the size of the blocks in the RT
> > > section.

mkfs.xfs -d extszinherit=NNN is what you want here.

> > > 
> > > Although, the 'extsize' command in xfs_io, will set the extent size
> > > hints on any
> > > file of any xfs filesystem (or filesystem supporting FS_IOC_FSSETXATTR).
> > > 
> > > Notice you can use xfs_io extsize to set the extent size hint to a
> > > directory,
> > > and all files under the directory will inherit the same extent hint.
> > 
> > My bad, I forgot about xfs_io.
> > Thanks for the detailed explanation.
> 
> Well, I did some test with a reflinked file and I must say I am impressed on
> how well XFS handles small rewrites (for example 4K).
> 
> From my understanding, by mapping at 4K granularity but allocating at 128K,
> it avoid most read/write amplification *and* keep low fragmentation. After
> "speculative_cow_prealloc_lifetime" it reclaim the allocated but unused
> space, bringing back any available free space to the filesystem. Is this
> understanding correct?

Right.

> I have a question: how can I see the allocated-but-unused cow extents? For
> example, giving the following files:
> 
> [root@neutron xfs]# stat test.img copy.img
>   File: test.img
>   Size: 1073741824      Blocks: 2097400    IO Block: 4096   regular file
> Device: 810h/2064d      Inode: 131         Links: 1
> Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)
> Context: unconfined_u:object_r:unlabeled_t:s0
> Access: 2020-01-13 15:40:50.280711297 +0100
> Modify: 2020-01-13 16:21:55.564726283 +0100
> Change: 2020-01-13 16:21:55.564726283 +0100
>  Birth: -
> 
>   File: copy.img
>   Size: 1073741824      Blocks: 2097152    IO Block: 4096   regular file
> Device: 810h/2064d      Inode: 132         Links: 1
> Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)
> Context: unconfined_u:object_r:unlabeled_t:s0
> Access: 2020-01-13 15:40:50.280711297 +0100
> Modify: 2020-01-13 15:40:57.828552412 +0100
> Change: 2020-01-13 15:41:48.190492279 +0100
>  Birth: -
> 
> I can clearly see that test.img has an additional 124K allocated after a 4K
> rewrite. This matches my expectation: a 4K rewrite really allocates a 128K
> blocks, leading to 124K of temporarily "wasted" space.
> 
> But both "filefrag -v" and "xfs_bmap -vep" show only the used space as seen
> by an userspace application (ie: 262144 blocks of 4096 bytes = 1073741824
> bytes).

xfs_bmap -c, but only if you have xfs debugging enabled.

> How can I check the total allocated space as reported by stat?
> Thanks.

If you happen to have rmap enabled, you can use the xfs_io fsmap command
to look for 'cow reservation' blocks, since that 124k is (according to
ondisk metadata, anyway) owned by the refcount btree until it gets
remapped into the file on writeback.

--D

> -- 
> Danti Gionatan
> Supporto Tecnico
> Assyoma S.r.l. - www.assyoma.it
> email: g.danti@assyoma.it - info@assyoma.it
> GPG public key ID: FF5F32A8
