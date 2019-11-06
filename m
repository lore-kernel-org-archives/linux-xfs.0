Return-Path: <SRS0=KqY6=Y6=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7404DC5DF63
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Nov 2019 19:07:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 42A4E2075C
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Nov 2019 19:07:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FBV3Jzus"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728253AbfKFTHs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Nov 2019 14:07:48 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:34510 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727319AbfKFTHs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Nov 2019 14:07:48 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA6J41KG050375;
        Wed, 6 Nov 2019 19:07:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=ZxkFRVdIx+IvbKVzeRwPzbFJYubg+ZGf8qbpcbLC+pY=;
 b=FBV3Jzus5Jrbo5KM4flJMfIEmS1J/BuUkY3cJUJO5yDjeioOF19aTzD9da5tkj6Yd/D3
 0YVMlAU/RkiPcs3do/ylUJnWRIMxW+ZrJPGIle9isnu/FEkwj57PfHLO1y5Vk/eLBAX6
 n0lE+KyoFqyl2wfFfnC0aeG4HFQLD2JXpsPy/BCFAJOTwkW/AgOvTypO3cBeZGVObez9
 MuzalUDpGuvau5t1bf+JjMOdUsB3J8ydiAFkzhOu1+PJHFSGy0IbVt2PfKBigAz+DxGR
 hNHz7m3vgsvLDtuHxpJujqrFFs4bvb0P+r9bQNCf6JnqUcIrhA6Wb+GxuMKUHNLKOdB/ Wg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2w41w0s256-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Nov 2019 19:07:44 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA6J3vcC162312;
        Wed, 6 Nov 2019 19:07:44 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2w41we1p8c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Nov 2019 19:07:44 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA6J7h3l028369;
        Wed, 6 Nov 2019 19:07:43 GMT
Received: from localhost (/10.159.234.83)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Nov 2019 11:07:43 -0800
Date:   Wed, 6 Nov 2019 11:07:42 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs_io/lsattr: expose FS_XFLAG_HASATTR flag
Message-ID: <20191106190742.GN4153244@magnolia>
References: <20191106055855.31517-1-amir73il@gmail.com>
 <20191106160139.GK4153244@magnolia>
 <CAOQ4uxhg=44nShrnmVYAgCGMno4QaeAZKc5cW8bko-dVOd_Scw@mail.gmail.com>
 <ab290f98-0992-43bd-9680-ef3db5142c8e@sandeen.net>
 <20191106185238.GM4153244@magnolia>
 <21d97237-03ef-7388-dbca-ab76ba304205@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21d97237-03ef-7388-dbca-ab76ba304205@sandeen.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9433 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=934
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911060186
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9433 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911060186
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 06, 2019 at 12:53:46PM -0600, Eric Sandeen wrote:
> 
> 
> On 11/6/19 12:52 PM, Darrick J. Wong wrote:
> > On Wed, Nov 06, 2019 at 12:45:55PM -0600, Eric Sandeen wrote:
> >> On 11/6/19 12:29 PM, Amir Goldstein wrote:
> 
> >>>>>  #define CHATTR_XFLAG_LIST    "r"/*p*/"iasAdtPneEfSxC"
> >>>>
> >>>> /me wonders if this should have /*X*/ commented out the same way we do
> >>>> for "p".
> >>>
> >>> Sure. Eric, please let me know if you want a re-submit for this.
> >>
> >> Ummm I'll just stage it now and add it so I don't forget
> >>
> >> like:
> >>
> >> #define CHATTR_XFLAG_LIST    "r"/*p*/"iasAdtPneEfS"/*X*/"xC"
> >>
> >> that, right?
> > 
> > Right.
> 
> 
> Actually for consistent ordering w/ the array, I guess maybe
> 
> #define CHATTR_XFLAG_LIST    "r"/*p*/"iasAdtPneEfSxC"/*X*/

Sure.  /me is done beating this hoss.
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> Thanks
> 
> -Eric
