Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4J55bVK032149 for <xfs@oss.sgi.com>; Tue, 19 May 2009 00:05:42 -0500
Received: from mail-fx0-f177.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 87BA6FCBD2D
	for <xfs@oss.sgi.com>; Mon, 18 May 2009 22:10:56 -0700 (PDT)
Received: from mail-fx0-f177.google.com (mail-fx0-f177.google.com
	[209.85.220.177]) by cuda.sgi.com with ESMTP id
	UZJoJCd0pF69J1vC for <xfs@oss.sgi.com>;
	Mon, 18 May 2009 22:10:56 -0700 (PDT)
Received: by fxm25 with SMTP id 25so3667457fxm.20
	for <xfs@oss.sgi.com>; Mon, 18 May 2009 22:05:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A11E27B.3010708@sandeen.net>
References: <6efe08af0905130010g5e21f4d1w9efb4ed200b5b152@mail.gmail.com>
	<4A0B0A71.5010609@sandeen.net>
	<6efe08af0905140150g623d5564i5f5a06b5bf8543a5@mail.gmail.com>
	<6efe08af0905150135q317d3b7dy37907332c02510c2@mail.gmail.com>
	<4A0F0325.8000908@sandeen.net> <4A11E27B.3010708@sandeen.net>
Date: Tue, 19 May 2009 05:05:45 +0000
Message-ID: <6efe08af0905182205q4e7712f3y91279df0f35d843e@mail.gmail.com>
Subject: Re: xfs_repair after reboot refuse repair my filesystem
From: "Vitaly V. Ch" <vitaly.v.ch@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

HI

at now I get my data repaired. By default configure enable DEBUG mode.
I force NDEBUG mode and xfs_repair successfully repair my data.

\\wbr Vitaly Chernookiy

On Mon, May 18, 2009 at 10:34 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
> Eric Sandeen wrote:
>
>> Is that the first repair of the image? =A0When I repair it on my box it
>> finds many more errors, and does not trip the assert. =A0I tested 3.0.1 =
in
>> fedora rawhide on x86 this time ...
>>
>> -Eric
>
> Oh, well, I'm dumb; the asserts do nothing unless you build with DEBUG
> on (as I guess you must have... they are off by default, as they are on
> my build) - I'll try to find some time to look into it.
>
> -Eric
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
