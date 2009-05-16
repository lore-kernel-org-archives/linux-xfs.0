Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4GI6FiH133961 for <xfs@oss.sgi.com>; Sat, 16 May 2009 13:06:15 -0500
Received: from ey-out-1920.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 08745BF7942
	for <xfs@oss.sgi.com>; Sat, 16 May 2009 11:11:20 -0700 (PDT)
Received: from ey-out-1920.google.com (ey-out-1920.google.com [74.125.78.147])
	by cuda.sgi.com with ESMTP id OF5u6EUpoHsdaFtu for
	<xfs@oss.sgi.com>; Sat, 16 May 2009 11:11:20 -0700 (PDT)
Received: by ey-out-1920.google.com with SMTP id 4so650982eyg.32
	for <xfs@oss.sgi.com>; Sat, 16 May 2009 11:06:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A0EF228.3010702@sandeen.net>
References: <554e24be0905160915l49ff901bn41e4332349c555bc@mail.gmail.com>
	<4A0EF228.3010702@sandeen.net>
Date: Sat, 16 May 2009 14:06:22 -0400
Message-ID: <554e24be0905161106x6a62b7bldc65325ac4102628@mail.gmail.com>
Subject: Re: quick question about filename length
From: Chris Walker <christopher.walker@gmail.com>
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

Thanks for you quick reply, Eric.

I have a user who is having filenames (path+filename) cut off at 255
characters midway through a simulation -- but the problem must be
elsewhere

Thanks again,
Chris

On Sat, May 16, 2009 at 1:04 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
> Chris Walker wrote:
>> Hello,
>>
>> I see that
>> #define MAXNAMELEN =A0256
>>
>> Is this the maximum length of the filename with full path? =A0Or is this
>> just the name of the file?
>>
>> Many thanks!
>> Chris
>
> /*
> =A0* MAXNAMELEN is the length (including the terminating null) of
> =A0* the longest permissible file (component) name.
> =A0*/
> #define MAXNAMELEN =A0 =A0 =A0256
>
> "component" means path component. =A0So just the name of the file or dir
> in the path.
>
> See also how it's used in xfs_vn_lookup() for example:
>
> =A0 =A0 =A0 =A0if (dentry->d_name.len >=3D MAXNAMELEN)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return ERR_PTR(-ENAMETOOLONG);
>
> a dentry is one component of the path, not the entire path.
>
> -Eric
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
