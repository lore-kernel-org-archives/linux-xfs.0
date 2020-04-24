Return-Path: <SRS0=lEGq=6I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E93AC54FD0
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Apr 2020 17:45:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F159520774
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Apr 2020 17:45:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Xl0aR5di"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727033AbgDXRpW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Apr 2020 13:45:22 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:36800 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727059AbgDXRpW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Apr 2020 13:45:22 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03OHgw78129993;
        Fri, 24 Apr 2020 17:44:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=XLzRTz9lDrH/JBqhTOj3mzZ8hHIYzXvEf5eZFCai7g8=;
 b=Xl0aR5divV35rmq7RWdwDqdHEyojYOmxfed4inywj0wB1vykHW7raiCxTpEflRTZufww
 T1JUkB2BfMDMsfGlxVnQjduZY6sIpF2yos5xOCuVKop/EotmsM+05/paKHkCbYk7LtvH
 NkCLh1nkUJKGhzCFRJK8rTNQSzrp+SR45yPsWuD+ODaxZMUWQN7cCrkww/uo0pTHXmyn
 aszjOiphBo7NB8HuPR0DF3f3tcQrZ+0NuLSgcPeZCEhot3H9aeoBgHHm7286MyRehBOR
 gaoBFLaGBb8cDzF0K2T/11+S0X4EqptC5Yj+pDPX0DMNAp/yLdh50r/Z0Pc7Rzt3XU3x nw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 30ketdnphf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Apr 2020 17:44:59 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03OHflMh038422;
        Fri, 24 Apr 2020 17:42:58 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 30gb3xs6q9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Apr 2020 17:42:58 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03OHguaK022439;
        Fri, 24 Apr 2020 17:42:57 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 24 Apr 2020 10:42:55 -0700
Date:   Fri, 24 Apr 2020 10:42:54 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Eric Sandeen <sandeen@sandeen.net>,
        Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfsprogs: don't warn about packed members
Message-ID: <20200424174254.GN6742@magnolia>
References: <20191216215245.13666-1-david@fromorbit.com>
 <20200126110212.GA23829@infradead.org>
 <029fa407-6bf5-c8c0-450a-25bded280fec@sandeen.net>
 <20200312140910.GA11758@infradead.org>
 <b6c1fed7-9e98-7d35-c489-bcdd2a6f9a23@sandeen.net>
 <20200424103323.GA10781@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200424103323.GA10781@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9601 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 suspectscore=0 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004240135
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9601 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 spamscore=0
 impostorscore=0 bulkscore=0 mlxlogscore=999 phishscore=0 mlxscore=0
 priorityscore=1501 clxscore=1015 suspectscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004240135
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 24, 2020 at 03:33:23AM -0700, Christoph Hellwig wrote:
> On Fri, Mar 13, 2020 at 09:06:38AM -0500, Eric Sandeen wrote:
> > On 3/12/20 9:09 AM, Christoph Hellwig wrote:
> > > On Mon, Jan 27, 2020 at 11:43:02AM -0600, Eric Sandeen wrote:
> > >> On 1/26/20 5:02 AM, Christoph Hellwig wrote:
> > >>> Eric, can you pick this one up?  The warnings are fairly annoying..
> > >>>
> > >>
> > >> Sorry, I had missed this one and/or the feedback on the original patch
> > >> wasn't resolved.  I tend to agree that turning off the warning globally
> > >> because we know /this/ one is OK seems somewhat suboptimal.
> > >>
> > >> Let me take a look again.
> > > 
> > > Can we get this queued up in xfsprogs?  These warnings are pretty
> > > annoying..
> > 
> > 
> > Ok.  I don't really like disabling it globally but if it's good enough
> > for the kernel... I'll add this to 5.5.0 and push out the release.
> 
> Seems like this still isn't in xfsprogs for-next.

Odd, it's in origin/master in my tree as the last commit before v5.5.0:
845e5ef706cb7e29259d6541f43a7029e7dc7898.

--D
