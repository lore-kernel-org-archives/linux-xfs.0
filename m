Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7SJgR9i172118 for <xfs@oss.sgi.com>; Fri, 28 Aug 2009 14:42:42 -0500
Received: from mx2.empa.ch (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2D93E157DDD4
	for <xfs@oss.sgi.com>; Fri, 28 Aug 2009 12:43:12 -0700 (PDT)
Received: from mx2.empa.ch (mx2.empa.ch [152.88.7.32]) by cuda.sgi.com with
	ESMTP id eoMTFn6eDa7ADE8G for <xfs@oss.sgi.com>;
	Fri, 28 Aug 2009 12:43:12 -0700 (PDT)
From: "Passerone, Daniele" <Daniele.Passerone@empa.ch>
Date: Fri, 28 Aug 2009 21:42:55 +0200
Subject: RE: xfs data loss
Message-ID: <B9A7B002C7FAFC469D4229539E909760308DA653F9@DU-EXC-MAIL.empa.emp-eaw.ch>
References: <B9A7B002C7FAFC469D4229539E909760308DA651DE@DU-EXC-MAIL.empa.emp-eaw.ch>
	<4A975A35.3060809@sandeen.net>
	<B9A7B002C7FAFC469D4229539E909760308DA65345@DU-EXC-MAIL.empa.emp-eaw.ch>
	<4A981133.6060009@sandeen.net>
In-Reply-To: <4A981133.6060009@sandeen.net>
Content-Language: en-US
MIME-Version: 1.0
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Hi Eric, 
and thank you for your attention and your time.
>
>Ok then perhaps I don't know what you mean by "power shock"
>
We work at a Materials science center, and there are big plants for 
simulating earthquakes or so (believe it or not).
These plants have sometimes the side effect of inducing strong 
destabilizations in the power supply. 
We suspect that such destabilization could have induced 
an effect in the system of 48 drives which constitutes our NAS server.
But of course, this is only an hypotesis.
>
>On the server as well?  Or just clients?  -really- no server-side errors
>in the logs?
>
Really. 
>Are you sure the storage hardware & the md volume is in ok shape?

This is a very good question. 
Indeed, the md volume (md6) close to the affected one (md4) showed loss of 2 disks upon reboot, but a 
repair of THAT filesystem (md6) worked. 

>
>Not yet, still wondering what really happened.
>
Me too
Thanks a lot.

Daniele

>-eric
>
>> Thank you!
>>
>> Daniele
>>
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs
>>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
