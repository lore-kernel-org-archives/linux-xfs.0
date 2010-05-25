Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4P8gRBv236781 for <xfs@oss.sgi.com>; Tue, 25 May 2010 03:42:27 -0500
Received: from oxalide-out.extra.cea.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6F10136CF61
	for <xfs@oss.sgi.com>; Tue, 25 May 2010 01:44:48 -0700 (PDT)
Received: from oxalide-out.extra.cea.fr (oxalide-out.extra.cea.fr
	[132.168.224.1]) by cuda.sgi.com with ESMTP id j3QqnZOycQd9OrQm
	for <xfs@oss.sgi.com>; Tue, 25 May 2010 01:44:48 -0700 (PDT)
Received: from pisaure.intra.cea.fr (pisaure.intra.cea.fr [132.166.88.21])
	by oxalide.extra.cea.fr (8.14.2/8.14.2/CEAnet-Internet-out-2.0) with
	ESMTP id o4P8ilbk029441
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <xfs@oss.sgi.com>; Tue, 25 May 2010 10:44:48 +0200
Received: from muguet1.intra.cea.fr (muguet1.intra.cea.fr [132.166.192.6])
	by pisaure.intra.cea.fr (8.14.4/8.14.4) with ESMTP id o4P8il2f019282
	for <xfs@oss.sgi.com>; Tue, 25 May 2010 10:44:47 +0200
	(envelope-from Philippe.DENIEL@CEA.FR)
Received: from zia.bruyeres.cea.fr (esteban.dam.intra.cea.fr [132.165.76.10])
	by muguet1.intra.cea.fr (8.13.8/8.13.8/CEAnet-Intranet-out-1.1) with
	SMTP id o4P8ilG8005274
	for <xfs@oss.sgi.com>; Tue, 25 May 2010 10:44:47 +0200
Message-ID: <4BFB8DFF.5040306@cea.fr>
Date: Tue, 25 May 2010 10:44:47 +0200
From: DENIEL Philippe <philippe.deniel@CEA.FR>
MIME-Version: 1.0
Subject: Re: open_by_handle on a file ?
References: <4BEACBC0.3080300@cea.fr> <20100512222147.GD13617@dastard>
In-Reply-To: <20100512222147.GD13617@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Thank you Dave, you were definitely right. I used the XFS mount point as =

the argument to  path_to_fshandle and it now woks perfectly. :-)
This leads me to another question : now that I can convert a path to =

fhandle and use it to open a file or a directory, I can use getdents and =

the ATFILE_SOURCE functions (mkdirat, linkat, ....) to implement the NFS =

logic (I just have to "open_by_handle" to get the fs to the related fs =

object and operate on it). The idea behind this is implementing a NFS =

server in Userspace with XFS specific capabilites.
In fact, the NFS on which a minor issue remains is LOOKUP (and it could =

become a major issue since LOOKUP is called very often). To lookup on an =

object knowing its parent directory's handle and its name, I can perform =

an "openat" followed by a xfs related "fd_to_handle" and close the fd =

once the operation is done. But it seems a bit "heavy" to me. Is there =

another (lighter) way of getting the handle to an object knowing its =

name and parent directory (may be by a call to xfsctl ?).

  Regards,

    Philippe

Dave Chinner a =E9crit :
> On Wed, May 12, 2010 at 05:39:44PM +0200, DENIEL Philippe wrote:
>   =

>> Hi,
>>
>> I start using libhandle.so from xfsprogs-3.0.3 package. I meet an
>> issue here : I can get a handle from files or directory.
>> When used on diretories, open_by_handle works fine : I can read
>> entries in it by using getdents, create stuff / removing stuff by
>> using the ATFILE_FUNCTION (mkdirat, renameat, ...)
>>
>> Trouble start when I want to open a file with open_by_handle. I have
>> a small test program that does this :
>>
>>        rc =3D path_to_fshandle( path_dir,  (void **)(&fshandle),
>>    &fshandlelen) ;
>>      if( rc < 0 ) exit( -1)
>>      rc =3D path_to_handle( path_dir,  (void **)(&filehandle), &handlele=
n) ;
>>      if( rc < 0 ) exit( -1 )
>>
>>      fd =3D open_by_handle( filehandle, handlelen, O_RDONLY ) ;
>>      printf( "open_by_handle: fd=3D%d \n", fd ) ;
>>      if( fd < 0 )
>>           printf( "----> Error=3D%d | %s\n", errno, strerror( errno ) ) ;
>>
>> The open_by_handle failed with errno=3D20 aka ENOTDIR, which is true,
>> this is a file and no directory.
>>     =

>
> I think that is because the path_dir points to a regular file and
> so path_to_fshandle() is generating a fshandle that points to a file
> instead of a directory. This handle is cached inside libhandle, and
> then use for subsequent handle calls like open_by_handle(). The
> kernel rejects the request is the fshandle does not point to a
> directory.
>
> Try using the mount point or a directory within the mount for
> the path_to_fshandle() call and see if that fixes the problem.
>
> Cheers,
>
> Dave.
>   =


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
