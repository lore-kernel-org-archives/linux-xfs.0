Return-Path: <SRS0=KqY6=Y6=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D620FC5DF63
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Nov 2019 18:52:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B67620869
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Nov 2019 18:52:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="M9LKIDq6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727740AbfKFSwp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Nov 2019 13:52:45 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:44716 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727351AbfKFSwp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Nov 2019 13:52:45 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA6Injpr037903;
        Wed, 6 Nov 2019 18:52:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=eElYRJWHCSu6ivNjKGbl8b/O8hX9sw/jNlMFzfnqU1Q=;
 b=M9LKIDq6XbvmTiIWXRzHGZV36GjQBkm3JibRj2akjsUVW2zP4ro23AavBFZSlHGNK8Ad
 /9JpNx1zVFuMX45mcTLMfulO8gEmxfqZe4wr5TpW9lCPWyR2k/wadMEgRk5KCOFR9fod
 GXC+DflRBG24x58DKXovUuaMTouWLodc+jxE/Tc/M6SDVKnzW6gI40wDCS/t/zC920Zn
 cWY4cRE0Xtxmk2JqY94ZGDds0FDGiq+fc91x4L4k1tXz3elwEWetj86lFjPb7jXcn81F
 wQTGhx7yJJgZyiI1UqgaSaBdlkR9doX7AodPLo912y8VPYBcdLrdJcGksHFiGNR1RmFV uQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2w41w0rya2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Nov 2019 18:52:41 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA6IndUx146605;
        Wed, 6 Nov 2019 18:52:41 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2w41w7rnu6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Nov 2019 18:52:41 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA6IqdiQ018605;
        Wed, 6 Nov 2019 18:52:40 GMT
Received: from localhost (/10.159.234.83)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Nov 2019 10:52:39 -0800
Date:   Wed, 6 Nov 2019 10:52:38 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs_io/lsattr: expose FS_XFLAG_HASATTR flag
Message-ID: <20191106185238.GM4153244@magnolia>
References: <20191106055855.31517-1-amir73il@gmail.com>
 <20191106160139.GK4153244@magnolia>
 <CAOQ4uxhg=44nShrnmVYAgCGMno4QaeAZKc5cW8bko-dVOd_Scw@mail.gmail.com>
 <ab290f98-0992-43bd-9680-ef3db5142c8e@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ab290f98-0992-43bd-9680-ef3db5142c8e@sandeen.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9433 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911060184
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9433 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911060184
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 06, 2019 at 12:45:55PM -0600, Eric Sandeen wrote:
> On 11/6/19 12:29 PM, Amir Goldstein wrote:
> > On Wed, Nov 6, 2019 at 6:03 PM Darrick J. Wong <darrick.wong@oracle.com> wrote:
> >>
> >> On Wed, Nov 06, 2019 at 07:58:55AM +0200, Amir Goldstein wrote:
> >>> For efficient check if file has xattrs.
> >>>
> >>> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> >>> ---
> >>>  io/attr.c | 2 ++
> >>>  1 file changed, 2 insertions(+)
> >>>
> >>> diff --git a/io/attr.c b/io/attr.c
> >>> index b713d017..ba88ef16 100644
> >>> --- a/io/attr.c
> >>> +++ b/io/attr.c
> >>> @@ -37,6 +37,7 @@ static struct xflags {
> >>>       { FS_XFLAG_FILESTREAM,          "S", "filestream"       },
> >>>       { FS_XFLAG_DAX,                 "x", "dax"              },
> >>>       { FS_XFLAG_COWEXTSIZE,          "C", "cowextsize"       },
> >>> +     { FS_XFLAG_HASATTR,             "X", "has-xattr"        },
> >>>       { 0, NULL, NULL }
> >>>  };
> >>>  #define CHATTR_XFLAG_LIST    "r"/*p*/"iasAdtPneEfSxC"
> >>
> >> /me wonders if this should have /*X*/ commented out the same way we do
> >> for "p".
> > 
> > Sure. Eric, please let me know if you want a re-submit for this.
> 
> Ummm I'll just stage it now and add it so I don't forget
> 
> like:
> 
> #define CHATTR_XFLAG_LIST    "r"/*p*/"iasAdtPneEfS"/*X*/"xC"
> 
> that, right?

Right.

--D

> >>
> >> Otherwise, the patch looks ok to me...
> >>
> >> /me *also* wonders how many filesystems fail to implement this flag but
> >> support xattrs.
> >>
> >> Oh.  All of them.  Though I assume overlayfs is being patched... :)
> >>
> > 
> > It doesn't need to be patched. It doesn't have xattr storage of its own.
> > The ioctl is passed down to the underlying fs (*).
> > (*) The ioctl is currently blocked on overlayfs directories.
> > 
> > Thanks,
> > Amir.
> > 
