Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o527I609059484 for <xfs@oss.sgi.com>; Wed, 2 Jun 2010 02:18:07 -0500
Received: from oxalide-out.extra.cea.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 08BFA38D45E
	for <xfs@oss.sgi.com>; Wed,  2 Jun 2010 00:20:32 -0700 (PDT)
Received: from oxalide-out.extra.cea.fr (oxalide-out.extra.cea.fr
	[132.168.224.1]) by cuda.sgi.com with ESMTP id SY3BLFwflE14oPsy
	for <xfs@oss.sgi.com>; Wed, 02 Jun 2010 00:20:32 -0700 (PDT)
Received: from pisaure.intra.cea.fr (pisaure.intra.cea.fr [132.166.88.21])
	by oxalide.extra.cea.fr (8.14.2/8.14.2/CEAnet-Internet-out-2.0) with
	ESMTP id o527KVUf010946
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <xfs@oss.sgi.com>; Wed, 2 Jun 2010 09:20:32 +0200
Received: from muguet2.intra.cea.fr (muguet2.intra.cea.fr [132.166.192.7])
	by pisaure.intra.cea.fr (8.14.4/8.14.4) with ESMTP id o527KVZ6016446
	for <xfs@oss.sgi.com>; Wed, 2 Jun 2010 09:20:31 +0200
	(envelope-from Philippe.DENIEL@CEA.FR)
Received: from zia.bruyeres.cea.fr (esteban.dam.intra.cea.fr [132.165.76.10])
	by muguet2.intra.cea.fr (8.13.8/8.13.8/CEAnet-Intranet-out-1.1) with
	SMTP id o527KVmU000600
	for <xfs@oss.sgi.com>; Wed, 2 Jun 2010 09:20:31 +0200
Message-ID: <4C06063F.1000609@cea.fr>
Date: Wed, 02 Jun 2010 09:20:31 +0200
From: DENIEL Philippe <philippe.deniel@CEA.FR>
MIME-Version: 1.0
Subject: Re: xfsprogs/libhandle : How to get the handle for a symbolic link ?
References: <4C04F386.908@cea.fr> <20100601232917.GG1395@dastard>
In-Reply-To: <20100601232917.GG1395@dastard>
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

Hi Dave,

In fact, path_to_handle does not do the work correctly. Its code is this =

(extract from xfsprogs-3.0.3 sources) :

    int
    path_to_handle(
            char            *path,          /* input,  path to convert */
            void            **hanp,         /* output, pointer to data */
            size_t          *hlen)          /* output, size of returned
    data */
    {
            int             fd;
            int             result;
            comarg_t        obj;

            fd =3D open(path, O_RDONLY);
            if (fd < 0)
                    return -1;

            obj.path =3D path;
            result =3D obj_to_handle(path, fd, XFS_IOC_PATH_TO_HANDLE,
                                    obj, hanp, hlen);
            close(fd);
            return result;
    }

As you see, it performs a open at the beginning, which will results in =

opening the file pointed by the symlink or returns ENOENT if the path =

"inside" the symlink does not exist. I tried using open with O_NOFOLLOW =

option, but it changed nothing, I got ELOOP when opening the file (which =

is a regular behavior so far).
Any other ideas ?

    Philippe



Dave Chinner a =E9crit :
> On Tue, Jun 01, 2010 at 01:48:22PM +0200, DENIEL Philippe wrote:
>   =

>> Hi,
>>
>> I am currently developing a user space nfs server with various
>> backends. One of this backend module use xfsprogss's libhandle to
>> implement XFS support. I could do almost everything with
>> open_by_handle and fd_to_handle, used jointly with ATFILE_SOURCE
>> functions, but I do have a problem with symbolic links. To build an
>> xfs object's handle, I get its parent handle (now problem to this)
>> then I call "openat" to get the fd to the object before calling
>> fd_to_handle. This works ok, but not for symbolic link : the openat
>> with follow the link. I added the O_NOFOLLOW flag to openat, but now
>> openat return ELOOP instead.
>> I know there is a readlink_by_handle function in libhandle. How
>> could I build the related handle to be used as argument to it (I
>> mean, how to build a handle that refers to the symlink itself, not
>> the object it points to).
>>     =

>
> Doesn't path_to_handle() do what you want? From the man page:
>
> 	"... If the final component of the path name is a symbolic
> 	link, the handle returned is that of the link itself."
>
> Cheers,
>
> Dave.
>   =


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
