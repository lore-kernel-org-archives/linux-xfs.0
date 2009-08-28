Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7SHGsZh166802 for <xfs@oss.sgi.com>; Fri, 28 Aug 2009 12:17:04 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2CB831B8153E
	for <xfs@oss.sgi.com>; Fri, 28 Aug 2009 10:17:41 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id 9RoKwHMnG03IymVk for
	<xfs@oss.sgi.com>; Fri, 28 Aug 2009 10:17:41 -0700 (PDT)
Message-ID: <4A981133.6060009@sandeen.net>
Date: Fri, 28 Aug 2009 10:17:39 -0700
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs data loss
References: <B9A7B002C7FAFC469D4229539E909760308DA651DE@DU-EXC-MAIL.empa.emp-eaw.ch>	<4A975A35.3060809@sandeen.net>
	<B9A7B002C7FAFC469D4229539E909760308DA65345@DU-EXC-MAIL.empa.emp-eaw.ch>
In-Reply-To: <B9A7B002C7FAFC469D4229539E909760308DA65345@DU-EXC-MAIL.empa.emp-eaw.ch>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: "Passerone, Daniele" <Daniele.Passerone@empa.ch>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Passerone, Daniele wrote:
>>> Due to a power shock, suddenly and without log messages about one half
>> (5 TB) of the user
>>> directories on /dev/md4 have disappeared.
>> I presume you mean after a reboot?
> 
> 
> 
> No! No reboot at all.

Ok then perhaps I don't know what you mean by "power shock"

> The directories were mounted via nfs to all our cluster,
> and are of the type 
> 
> /pool/user
> 
> all directories from 
> 
> /pool/g*
> 
> to
> 
> /pool/z*
> 
> have disappeared.

On the server as well?  Or just clients?  -really- no server-side errors 
in the logs?

Are you sure the storage hardware & the md volume is in ok shape?

> Of course NO COMMAND of the kind rm /pool/[g-z]* was issued.
> 
>> Were the lost directories recently created?  I've never heard of
>> untouched, existing directories disappearing after a power loss...
>>
> 
> Not at all.
> Here I am.
>> Not much to go on here I'm afraid.  SLES10 is an old kernel, but it's
>> supported by SuSE at least.
>>
> 
> Can you use my metadata, or is it useless?

Not yet, still wondering what really happened.

-eric

> Thank you!
> 
> Daniele
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
