Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o65FUtfp127292 for <xfs@oss.sgi.com>; Mon, 5 Jul 2010 10:30:55 -0500
Received: from mail-ww0-f41.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A549D429ACB
	for <xfs@oss.sgi.com>; Mon,  5 Jul 2010 08:33:45 -0700 (PDT)
Received: from mail-ww0-f41.google.com (mail-ww0-f41.google.com
	[74.125.82.41]) by cuda.sgi.com with ESMTP id 5PhDcZx0VLOW9aNE
	for <xfs@oss.sgi.com>; Mon, 05 Jul 2010 08:33:45 -0700 (PDT)
Received: by wwb17 with SMTP id 17so1191583wwb.2
	for <xfs@oss.sgi.com>; Mon, 05 Jul 2010 08:33:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100705171338.3bb38e1d@harpe.intellique.com>
References: <AANLkTinPmhJRD3CDdsHtkLFzYd2jF9ee7gPqgO6XBSfl@mail.gmail.com>
	<20100705171338.3bb38e1d@harpe.intellique.com>
Date: Mon, 5 Jul 2010 18:33:44 +0300
Message-ID: <AANLkTim5GfiDw63CwrE1QMwQACpWd2OgDgEW8y8bpcSW@mail.gmail.com>
Subject: Re: Slow delete
From: Andrei Deftu <andreideftu@gmail.com>
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
To: Emmanuel Florac <eflorac@intellique.com>
Cc: xfs@oss.sgi.com

On Mon, Jul 5, 2010 at 6:13 PM, Emmanuel Florac <eflorac@intellique.com> wr=
ote:
> Le Mon, 5 Jul 2010 17:27:44 +0300
> Andrei Deftu <andreideftu@gmail.com> =E9crivait:
>
>> As many people have pointed out, xfs is very slow when deleting a
>> large number of files. Does anyone has a technical answer to this
>> problem? Also, I am interested to know if there is a way to
>> temporarily speed up the delete process, regardless of all the other
>> parameters.
>
> Using the "nobarrier" mount option (when applicable/advisable)
> considerably speeds up metadata operations.
> Another possibility is to use a ramdisk (or /dev/null) as a log device
> though it could be... dangerous :)

Thanks. Yes, I know about these tricks like 'nobarrier' option,
separate partition for metadata log, increased size for the log, more
log buffers or atime disabled. But I was interested more in what is
the real cause of this slowness.

Andrei

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
