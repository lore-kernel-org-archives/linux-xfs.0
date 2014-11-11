Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0E5597F3F
	for <xfs@oss.sgi.com>; Tue, 11 Nov 2014 09:35:34 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EFC608F8049
	for <xfs@oss.sgi.com>; Tue, 11 Nov 2014 07:35:33 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id dxYidOFJiyLuHP4N
	for <xfs@oss.sgi.com>; Tue, 11 Nov 2014 07:35:32 -0800 (PST)
Message-ID: <54622CE8.7050508@hardwarefreak.com>
Date: Tue, 11 Nov 2014 09:36:08 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Enforcing quota for root user
References: <67EDE14C-CCFB-4B42-8B78-FC6C813CD19A@free.fr>	<5461B333.8050609@hardwarefreak.com>
	<F7ACFF71-460D-40E7-999C-BFC8D232EA81@free.fr>
In-Reply-To: <F7ACFF71-460D-40E7-999C-BFC8D232EA81@free.fr>
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
To: Cyril Scetbon <cyril.scetbon@free.fr>
Cc: xfs@oss.sgi.com

On 11/11/2014 04:22 AM, Cyril Scetbon wrote:
> That's what I've read first, but someone showed me a sample where it works. He just told me he was using project quota. However, does it make sense ? 
> I've also read somewhere else that quota is never enforced for root user (id,gid=0) that's why I was testing it ....

No, it doesn't make sense.  Why would you want to enforce quotas for root?

Regards,
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
