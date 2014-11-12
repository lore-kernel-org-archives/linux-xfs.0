Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 14CC97F58
	for <xfs@oss.sgi.com>; Wed, 12 Nov 2014 07:56:04 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E80468F8033
	for <xfs@oss.sgi.com>; Wed, 12 Nov 2014 05:56:00 -0800 (PST)
Received: from mo6.mail-out.ovh.net (2.mo6.mail-out.ovh.net [46.105.76.65]) by
	cuda.sgi.com with ESMTP id lW9uEgYEZKivHEkN (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 12 Nov 2014 05:55:59 -0800 (PST)
Received: from mail617.ha.ovh.net (gw6.ovh.net [213.251.189.206])
	by mo6.mail-out.ovh.net (Postfix) with SMTP id E5D4BFFB648
	for <xfs@oss.sgi.com>; Wed, 12 Nov 2014 14:55:54 +0100 (CET)
Mime-Version: 1.0 (Mac OS X Mail 8.0 \(1990.1\))
Subject: Re: Enforcing quota for root user
From: Cyril Scetbon <cyril.scetbon@free.fr>
In-Reply-To: <54622CE8.7050508@hardwarefreak.com>
Date: Wed, 12 Nov 2014 14:55:52 +0100
Message-Id: <3D602DDB-31DA-4923-9737-C1895DF55F34@free.fr>
References: <67EDE14C-CCFB-4B42-8B78-FC6C813CD19A@free.fr>
	<5461B333.8050609@hardwarefreak.com>
	<F7ACFF71-460D-40E7-999C-BFC8D232EA81@free.fr>
	<54622CE8.7050508@hardwarefreak.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: xfs@oss.sgi.com

-- 
Cyril SCETBON

> On 11/11/2014 04:22 AM, Cyril Scetbon wrote:
>> That's what I've read first, but someone showed me a sample where it works. He just told me he was using project quota. However, does it make sense ? 
>> I've also read somewhere else that quota is never enforced for root user (id,gid=0) that's why I was testing it ....
> 
> No, it doesn't make sense.  

Cool I'm not crazy :)

> Why would you want to enforce quotas for root?

Cause I'm using a software that must be launched as root (a limitation that should be removed in the future) and I want to apply quota to that one !

> Regards,
> Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
