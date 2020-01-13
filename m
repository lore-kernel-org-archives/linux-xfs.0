Return-Path: <SRS0=9ni0=3C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D282C33CA9
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Jan 2020 18:09:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 705E6207FD
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Jan 2020 18:09:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fpIgpHDc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726985AbgAMSJp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Jan 2020 13:09:45 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:43766 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726435AbgAMSJo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Jan 2020 13:09:44 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00DI89MU155402;
        Mon, 13 Jan 2020 18:09:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=8CXIBTkMZKDmkj+GcKbThC8AhZgD4xXngtzKEVDhMGk=;
 b=fpIgpHDc2wdcD+fS6+lhXVOYNN+YcSmorA1sIaWT0m2DVHmdGKEk/31VJf+sTrkvj0GS
 mu+8oFuux60739PQBD98VM38W/MzzjAHwPChkfIReYh/WjNseMn/yOIYKQb5KnBXXrUn
 k4rbcdZBCTJlKF+ABpR0N8a2oawsz/nMQ1X3gk/8RnHEiNCIVG/CpWsz0yXkOemfkV/1
 GDpjIhE0GG1BycJbn21HlthkDm8U709KVeGGG8+5HKYE5ZZihbp3jwSFAjjb6SIFCZd1
 DoBwNSot3l6y/ikc6N6xQD75o1GJ8YxhIe3WFn7iKLyRDYmCu9ESaEV1FW9J6YXuGay3 LA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2xf73y8nrg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Jan 2020 18:09:41 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00DI9K1v167096;
        Mon, 13 Jan 2020 18:09:41 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2xfqu4xv5u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Jan 2020 18:09:36 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00DI9FOU007514;
        Mon, 13 Jan 2020 18:09:15 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 Jan 2020 10:09:15 -0800
Date:   Mon, 13 Jan 2020 10:09:14 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Gionatan Danti <g.danti@assyoma.it>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: XFS reflink vs ThinLVM
Message-ID: <20200113180914.GI8247@magnolia>
References: <fe697fb6-cef6-2e06-de77-3530700852da@assyoma.it>
 <20200113111025.liaargk3sf4wbngr@orion>
 <703a6c17-cc02-2c2c-31ce-6cd12a888743@assyoma.it>
 <20200113114356.midcgudwxpze3xfw@orion>
 <627cb07f-9433-ddfd-37d7-27efedd89727@assyoma.it>
 <39b50e2c-cb78-3bcd-0130-defa9c573b71@assyoma.it>
 <20200113165341.GE8247@magnolia>
 <f61995d7-9775-0035-8700-2b92c63bd23f@assyoma.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f61995d7-9775-0035-8700-2b92c63bd23f@assyoma.it>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9499 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=943
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001130146
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9499 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001130146
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 13, 2020 at 06:00:15PM +0100, Gionatan Danti wrote:
> On 13/01/20 17:53, Darrick J. Wong wrote:
> > mkfs.xfs -d extszinherit=NNN is what you want here.
> 
> Hi Darrik, thank you, I missed that option.
> 
> > Right.
> 
> Ok
> 
> > xfs_bmap -c, but only if you have xfs debugging enabled.
> 
> [root@neutron xfs]# xfs_bmap -c test.img
> /usr/sbin/xfs_bmap: illegal option -- c
> Usage: xfs_bmap [-adelpvV] [-n nx] file...
> 
> Maybe my xfs_bmap version is too old:

Doh, sorry, thinko on my part.  -c is exposed in the raw xfs_io command
but not in the xfs_bmap wrapper.

xfs_io -c 'bmap -c -e -l -p -v <whatever>' test.img

> > If you happen to have rmap enabled, you can use the xfs_io fsmap command
> > to look for 'cow reservation' blocks, since that 124k is (according to
> > ondisk metadata, anyway) owned by the refcount btree until it gets
> > remapped into the file on writeback.
> 
> I see. By default, on RHEL at least, rmapbt is disabled. As a side note, do
> you suggest enabling it when creating a new fs?

If you are interested in online scrub, then I'd say yes because it's the
secret sauce that gives online metadata checking most of its power.  I
confess, I haven't done a lot of performance analysis of rmap lately,
the metadata ops overhead might still be in the ~10% range.

The two issues preventing rmap from being turned on by default (at least
in my head) are (1) scrub itself is still EXPERIMENTAL and (2) it's not
100% clear that online fsck is such a killer app that everyone will want
it, since you always pay the performance overhead of enabling rmap
regardless of whether you use xfs_scrub.

(If your workload is easily restored from backup/Docker and you need all
the performance you can squeeze then perhaps don't enable this.)

Note that I've been running with rmap=1 and scrub=1 on all systems since
2016, and frankly I've noticed the system stumbling over broken
writeback throttling much more than whatever the tracing tools attribute
to rmap.

--D

> Thanks.
> 
> -- 
> Danti Gionatan
> Supporto Tecnico
> Assyoma S.r.l. - www.assyoma.it
> email: g.danti@assyoma.it - info@assyoma.it
> GPG public key ID: FF5F32A8
