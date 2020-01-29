Return-Path: <SRS0=zOuE=3S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CC21C2D0DB
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jan 2020 19:31:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 013B32071E
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jan 2020 19:31:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="R5zmoWZc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727273AbgA2Tbx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jan 2020 14:31:53 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:33958 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726203AbgA2Tbx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jan 2020 14:31:53 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00TJBxD6174120;
        Wed, 29 Jan 2020 19:31:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=+mCQcIrciNLZfCIuODEIS3jXXla+IE/Ku0555E8sN30=;
 b=R5zmoWZcWOKvT4zzTUSmVNjFoauGBfWdgVQPAE/yeExDfycbGG0Tw3Fwb3sj7Hm6OarH
 dJ80cu948gR8G75E4z33cHV8Tnh9+dlGouQYoJCC0576Afsf5dmD/IgILEGK4ZtFJyJ9
 kLoirTR2/SgUIq56zA00xYmRUppu2XynJfdH6/kOgfBke6woPdaV41CjYHtyzDlKHYqM
 aG4+LnLCroC+hwkYNZVJki1EY7z7RBV5PqYJIUoGcsQm5R+deH4gCH2neaqKysSCPH6f
 OHZaIi0PMBKZMlwl7Pluk9bJO9t4WFmo3IIsYdDsMuM4PT82rp1ZVQSPsMkyDuNpwaiq Fw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2xrdmqqrd2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Jan 2020 19:31:49 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00TJCWP6131318;
        Wed, 29 Jan 2020 19:29:48 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2xu8e70hfh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Jan 2020 19:29:48 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00TJTk3M003179;
        Wed, 29 Jan 2020 19:29:48 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 29 Jan 2020 11:29:46 -0800
Date:   Wed, 29 Jan 2020 11:29:45 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH V2] xfsprogs: do not redeclare globals provided by
 libraries
Message-ID: <20200129192945.GV3447196@magnolia>
References: <0892b951-ac99-9f84-9c65-421798daa547@sandeen.net>
 <a2b9920e-8f65-31d8-8809-a862213117df@sandeen.net>
 <20200129160121.GS3447196@magnolia>
 <d9dd895f-8f16-ab11-b913-bf095c2b8071@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d9dd895f-8f16-ab11-b913-bf095c2b8071@sandeen.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9514 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001290152
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9514 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001290152
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 29, 2020 at 10:57:48AM -0600, Eric Sandeen wrote:
> On 1/29/20 10:01 AM, Darrick J. Wong wrote:
> > On Wed, Jan 29, 2020 at 09:16:58AM -0600, Eric Sandeen wrote:
> >> In each of these cases, db, logprint, and mdrestore are redeclaring
> >> as a global variable something which was already provided by a
> >> library they link with. 
> >>
> >> gcc now defaults to -fno-common and trips over these global variables
> >> which are declared in utilities as well as in libxfs and libxlog, and
> >> it causes the build to fail.
> >>
> >> Signed-off-by: Eric Sandeen <sandeen@redhat.com> 
> >> ---
> 
> ...
> 
> >> +	print_exit = 1; /* -e is now default. specify -c to override */ 
> > 
> > With the trailing whitespace after the comment fixed,
> 
> oh burn. ;)
> 
> > Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Though given your earlier comment on IRC, maybe we should investigate
> > why -fno-common would be useful (since Fedora turned it on??) or if it
> > should be in the regular build to catch multiply defined global vars?
> 
> That's a good idea.  FWIW my understanding is that it's a new default in
> gcc10.
> 
> Docs say w.r.t. -fcommon: "This behavior is inconsistent with C++, and on many targets implies a speed and code size penalty on global variable references. It is mainly useful to enable legacy code to link without errors."
> 
> Want me to send a V3 w/ -fno-common explicitly set?

Yes, that sounds like a better place to start a conversation about ...
whatever that option is. :)

--D

> -Eric
