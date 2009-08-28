Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7S9IvH2148343 for <xfs@oss.sgi.com>; Fri, 28 Aug 2009 04:19:13 -0500
Received: from mx1.empa.ch (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DCE191B80E79
	for <xfs@oss.sgi.com>; Fri, 28 Aug 2009 02:19:33 -0700 (PDT)
Received: from mx1.empa.ch (mx1.empa.ch [152.88.7.31]) by cuda.sgi.com with
	ESMTP id cKEamAIRbbJhw04e for <xfs@oss.sgi.com>;
	Fri, 28 Aug 2009 02:19:33 -0700 (PDT)
From: "Passerone, Daniele" <Daniele.Passerone@empa.ch>
Date: Fri, 28 Aug 2009 11:19:12 +0200
Subject: RE: xfs data loss
Message-ID: <B9A7B002C7FAFC469D4229539E909760308DA65345@DU-EXC-MAIL.empa.emp-eaw.ch>
References: <B9A7B002C7FAFC469D4229539E909760308DA651DE@DU-EXC-MAIL.empa.emp-eaw.ch>
	<4A975A35.3060809@sandeen.net>
In-Reply-To: <4A975A35.3060809@sandeen.net>
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

>> Due to a power shock, suddenly and without log messages about one half
>(5 TB) of the user
>> directories on /dev/md4 have disappeared.
>
>I presume you mean after a reboot?



No! No reboot at all.
The directories were mounted via nfs to all our cluster,
and are of the type 

/pool/user

all directories from 

/pool/g*

to

/pool/z*

have disappeared.

Of course NO COMMAND of the kind rm /pool/[g-z]* was issued.

>Were the lost directories recently created?  I've never heard of
>untouched, existing directories disappearing after a power loss...
>

Not at all.
Here I am.
>
>Not much to go on here I'm afraid.  SLES10 is an old kernel, but it's
>supported by SuSE at least.
>

Can you use my metadata, or is it useless?
Thank you!

Daniele

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
