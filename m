Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6CEDB7F3F
	for <xfs@oss.sgi.com>; Tue, 11 Nov 2014 04:23:03 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5B348304032
	for <xfs@oss.sgi.com>; Tue, 11 Nov 2014 02:23:00 -0800 (PST)
Received: from mo68.mail-out.ovh.net (4.mo68.mail-out.ovh.net [46.105.59.63])
	by cuda.sgi.com with ESMTP id a62Dt3jgKqzKTV4B (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 11 Nov 2014 02:22:58 -0800 (PST)
Received: from mail189.ha.ovh.net (b6.ovh.net [213.186.33.56])
	by mo68.mail-out.ovh.net (Postfix) with SMTP id 36C32FFB070
	for <xfs@oss.sgi.com>; Tue, 11 Nov 2014 11:22:52 +0100 (CET)
Mime-Version: 1.0 (Mac OS X Mail 8.0 \(1990.1\))
Subject: Re: Enforcing quota for root user
From: Cyril Scetbon <cyril.scetbon@free.fr>
In-Reply-To: <5461B333.8050609@hardwarefreak.com>
Date: Tue, 11 Nov 2014 11:22:49 +0100
Message-Id: <F7ACFF71-460D-40E7-999C-BFC8D232EA81@free.fr>
References: <67EDE14C-CCFB-4B42-8B78-FC6C813CD19A@free.fr>
	<5461B333.8050609@hardwarefreak.com>
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

That's what I've read first, but someone showed me a sample where it works. He just told me he was using project quota. However, does it make sense ? 
I've also read somewhere else that quota is never enforced for root user (id,gid=0) that's why I was testing it ....
-- 
Cyril SCETBON

> On 11 Nov 2014, at 07:56, Stan Hoeppner <stan@hardwarefreak.com> wrote:
> 
> 
> 
> On 11/10/2014 04:46 PM, Cyril Scetbon wrote:
>> Hi,
>> 
>> I'm trying to enforce quotas for the superuser without success. Can you
>> tell me what I'm doing wrong ?
> 
> http://xfs.org/docs/xfsdocs-xml-dev/XFS_User_Guide/tmp/en-US/html/ch08s04.html
> 
> Look at the last line.
> 
> Cheers,
> Stan
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
