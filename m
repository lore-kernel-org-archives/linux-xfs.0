Return-Path: <SRS0=uPG+=3K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07829C2D0CE
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jan 2020 18:37:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD56624125
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jan 2020 18:37:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OpFjymU2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729080AbgAUShM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Jan 2020 13:37:12 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:42814 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728901AbgAUShM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Jan 2020 13:37:12 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00LIS6IQ013018;
        Tue, 21 Jan 2020 18:37:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=kgSkzSv1KZAjRVhMIt1ZJ2PV7OEvuXe4iqzsE1/f/G0=;
 b=OpFjymU25lrHabMklMccAmewdMlol3Ux30I1gxew1l3Ju/o4i/QpSx6CHvQW2Zvs8mIY
 wIQPe2sQy/lfA6jJl2QAVPLGQaFLhRdiz/dk6k6gEcmFbF3a2WLHBtB6iK2PyfEmJsGb
 dPfRPEHs3OFebdPXW5bzIfjzIOQBVGzQlfufPxnNRXF0W73MdvMTWjpmKs6i9mJXqTBK
 twiEpnWNSPkdEgnNXFWe62w/mwqWVbaY8crlHp4mqgnnG3XGDq5I53veEhwoCKUBZXjS
 +wwj5LzZ/aE12vnRmeS4Ar5cQ+qk29Zv2VEEdqAA9RQ6GXFcx7jMLoxxXCgtSQIn0y0t JA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2xkseuf408-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jan 2020 18:37:08 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00LIT25t100971;
        Tue, 21 Jan 2020 18:37:08 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2xnsa95yq4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jan 2020 18:37:07 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00LIb7PI029035;
        Tue, 21 Jan 2020 18:37:07 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 Jan 2020 10:37:07 -0800
Date:   Tue, 21 Jan 2020 10:37:06 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs_repair: stop using ->data_entry_p()
Message-ID: <20200121183706.GQ8257@magnolia>
References: <2cf1f45b-b3b2-f630-50d5-ff34c000b0c8@redhat.com>
 <20200118043947.GO8257@magnolia>
 <57ab702d-0a66-8323-5e87-08aa315cf9c7@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57ab702d-0a66-8323-5e87-08aa315cf9c7@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9507 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001210139
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9507 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001210139
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 20, 2020 at 08:29:17AM -0600, Eric Sandeen wrote:
> On 1/17/20 10:39 PM, Darrick J. Wong wrote:
> > On Fri, Jan 17, 2020 at 05:17:11PM -0600, Eric Sandeen wrote:
> >> The ->data_entry_p() op went away in v5.5 kernelspace, so rework
> >> xfs_repair to use ->data_entry_offset instead, in preparation
> >> for the v5.5 libxfs backport.
> >>
> >> This could later be cleaned up to use offsets as was done
> >> in kernel commit 8073af5153c for example.
> > 
> > See, now that you've said that, I start wondering why not do that?
> 
> Because this is the fast/safe path to getting the libxfs merge done IMHO ;)
> 
> ...
> 
> 
> >> @@ -1834,7 +1834,7 @@ longform_dir2_entry_check_data(
> >>  			       (dep->name[0] == '.' && dep->namelen == 1));
> >>  			add_inode_ref(current_irec, current_ino_offset);
> >>  			if (da_bno != 0 ||
> >> -			    dep != M_DIROPS(mp)->data_entry_p(d)) {
> >> +			    dep != (void *)d + M_DIROPS(mp)->data_entry_offset) {
> > 
> > Er.... void pointer arithmetic?
> 
> er, let me take another look at that.

fmeh, we apparently allow this gcc extension in the kernel so I guess
it's fine for xfsprogs :P

--D

> -eric
> 
> 
