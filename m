Return-Path: <SRS0=K4IM=45=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C9C6C1975A
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 17:34:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2DC1920716
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 17:34:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MkLWOVRm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726299AbgCLReK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Mar 2020 13:34:10 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:51392 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726443AbgCLReK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Mar 2020 13:34:10 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02CHXFfU170583;
        Thu, 12 Mar 2020 17:34:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=8BXZkIBFdSV5Cqw9a0p1XxytIVsUq/oDjLXhAF0TQRo=;
 b=MkLWOVRm/jbx62m7Sj7yYErLpZAAyWb5Op7IrrWCc9YU/yaizUG8aZSZpv+CoY4Tl65Z
 h78KhULegOg90H3UEr02jweLR4W1G1bZWy79ZrOZlBJnmxjdw+hZ6sT5BmYLN6TH8qMv
 WtmbzmOfxxZy8fRihlflqorZ2dfMKM/Jqqo/CrYTzUtnL9Jp4RoAlJGHRC2zpSsfmxDm
 c4m/f5k5QYpM83TtaHXQjv4pEgbSJHTHFT4qOENsFjBFcvrqnvwJoobh+Krd5Of1U80Q
 TUk8gBRjSdP1lj5B0QIl85aSmbtUIgSB41izvEuI/h6OR+i6B9Axcg1wGStdGZcb72T3 aQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2yqkg8a6wj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Mar 2020 17:33:59 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02CHRHqi060642;
        Thu, 12 Mar 2020 17:33:59 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2yp8p82ymv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Mar 2020 17:33:59 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02CHXuXQ012396;
        Thu, 12 Mar 2020 17:33:57 GMT
Received: from [192.168.1.223] (/67.1.237.184)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 12 Mar 2020 10:33:56 -0700
Subject: Re: xfsprogs process question
To:     Eric Sandeen <sandeen@sandeen.net>,
        Eric Sandeen <sandeen@redhat.com>,
        Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
References: <20200312141351.GA30388@infradead.org>
 <244a8391-77c4-94a1-3bd4-b78c7a1f39ad@redhat.com>
 <445406be-4d04-1834-0afc-d8af31271c95@oracle.com>
 <5c72513c-bcd4-5231-4567-998d0510407b@sandeen.net>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <f882f63b-d9a1-4926-8176-d864c208c707@oracle.com>
Date:   Thu, 12 Mar 2020 10:33:55 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <5c72513c-bcd4-5231-4567-998d0510407b@sandeen.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9558 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 spamscore=0 malwarescore=0 adultscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003120089
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9558 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 lowpriorityscore=0
 mlxlogscore=999 spamscore=0 phishscore=0 adultscore=0 impostorscore=0
 malwarescore=0 priorityscore=1501 suspectscore=0 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003120089
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 3/12/20 9:32 AM, Eric Sandeen wrote:
> On 3/12/20 11:17 AM, Allison Collins wrote:
>> I've often wondered how one person manages to keep up with that!  :-)
> 
> It seems that the answer is "badly" ;)
> 
> (TBH Darrick is a huge help here, in the long run.)
> 
> -Eric
> 
:-)  Wouldnt it make it easier though if people pushed a corresponding 
"xfsprogs: set name" that's already been applied/compiled and 
(hopefully) tested?  That way when the user space side needs updating, 
patches can just be applied without one person having to work through 
all the ports?  And then people could sort of cherry pick what they need 
off the list while the user space side is still between cycles.  I 
realize this would generate a lot more traffic on the mailing list, but 
it seems like a reasonable way that people could help address this 
bottle neck.

I think I must have redone the userspace side of the delayed attr series 
over a dozen times, and there's a few patches that are not perfect 
mirrors of their kernel space counter parts.  Because some changes 
affect code not present in the kernel space side, now all that needs 
updating too for the set as a whole to really work.  It kinda seems like 
submitting just the kernel space side is still only half the set.  Not 
sure how many other people run into that, but I suspect I'm likely not 
the first?

Allison
