Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o51Bjw8b249401 for <xfs@oss.sgi.com>; Tue, 1 Jun 2010 06:45:58 -0500
Received: from oxalide-out.extra.cea.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 711F715810B2
	for <xfs@oss.sgi.com>; Tue,  1 Jun 2010 04:50:41 -0700 (PDT)
Received: from oxalide-out.extra.cea.fr (oxalide-out.extra.cea.fr
	[132.168.224.1]) by cuda.sgi.com with ESMTP id 7JpYNcveo5qL24Yq
	for <xfs@oss.sgi.com>; Tue, 01 Jun 2010 04:50:41 -0700 (PDT)
Received: from pisaure.intra.cea.fr (pisaure.intra.cea.fr [132.166.88.21])
	by oxalide.extra.cea.fr (8.14.2/8.14.2/CEAnet-Internet-out-2.0) with
	ESMTP id o51BmN74030845
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <xfs@oss.sgi.com>; Tue, 1 Jun 2010 13:48:23 +0200
Received: from muguet1.intra.cea.fr (muguet1.intra.cea.fr [132.166.192.6])
	by pisaure.intra.cea.fr (8.14.4/8.14.4) with ESMTP id o51BmMfK018772
	for <xfs@oss.sgi.com>; Tue, 1 Jun 2010 13:48:22 +0200
	(envelope-from Philippe.DENIEL@CEA.FR)
Received: from zia.bruyeres.cea.fr (esteban.dam.intra.cea.fr [132.165.76.10])
	by muguet1.intra.cea.fr (8.13.8/8.13.8/CEAnet-Intranet-out-1.1) with
	SMTP id o51BmMhh018938
	for <xfs@oss.sgi.com>; Tue, 1 Jun 2010 13:48:22 +0200
Message-ID: <4C04F386.908@cea.fr>
Date: Tue, 01 Jun 2010 13:48:22 +0200
From: DENIEL Philippe <philippe.deniel@CEA.FR>
MIME-Version: 1.0
Subject: xfsprogs/libhandle : How to get the handle for a symbolic link ?
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
To: xfs@oss.sgi.com

Hi,

I am currently developing a user space nfs server with various backends. 
One of this backend module use xfsprogss's libhandle to implement XFS 
support. I could do almost everything with open_by_handle and 
fd_to_handle, used jointly with ATFILE_SOURCE functions, but I do have a 
problem with symbolic links. To build an xfs object's handle, I get its 
parent handle (now problem to this) then I call "openat" to get the fd 
to the object before calling fd_to_handle. This works ok, but not for 
symbolic link : the openat with follow the link. I added the O_NOFOLLOW 
flag to openat, but now openat return ELOOP instead.
I know there is a readlink_by_handle function in libhandle. How could I 
build the related handle to be used as argument to it (I mean, how to 
build a handle that refers to the symlink itself, not the object it 
points to).

    Regards

       Philippe

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
