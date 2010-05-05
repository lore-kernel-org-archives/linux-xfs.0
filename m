Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o45DqrOd037882 for <xfs@oss.sgi.com>; Wed, 5 May 2010 08:52:53 -0500
Received: from cirse-out.extra.cea.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 714DA310CBF
	for <xfs@oss.sgi.com>; Wed,  5 May 2010 06:55:00 -0700 (PDT)
Received: from cirse-out.extra.cea.fr (cirse-out.extra.cea.fr
	[132.166.172.106]) by cuda.sgi.com with ESMTP id
	Vx2pz7iQ6IhA7oYe for <xfs@oss.sgi.com>;
	Wed, 05 May 2010 06:55:00 -0700 (PDT)
Received: from pisaure.intra.cea.fr (pisaure.intra.cea.fr [132.166.88.21])
	by cirse.extra.cea.fr (8.14.2/8.14.2/CEAnet-Internet-out-2.0) with
	ESMTP id o45Dsxgh022241
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <xfs@oss.sgi.com>; Wed, 5 May 2010 15:54:59 +0200
Received: from muguet2.intra.cea.fr (muguet2.intra.cea.fr [132.166.192.7])
	by pisaure.intra.cea.fr (8.14.4/8.14.4) with ESMTP id o45DsxjP017128
	for <xfs@oss.sgi.com>; Wed, 5 May 2010 15:54:59 +0200
	(envelope-from Philippe.DENIEL@CEA.FR)
Received: from zia.bruyeres.cea.fr (esteban.dam.intra.cea.fr [132.165.76.10])
	by muguet2.intra.cea.fr (8.13.8/8.13.8/CEAnet-Intranet-out-1.1) with
	SMTP id o45DsxZX001414
	for <xfs@oss.sgi.com>; Wed, 5 May 2010 15:54:59 +0200
Message-ID: <4BE178B3.8030501@cea.fr>
Date: Wed, 05 May 2010 15:54:59 +0200
From: DENIEL Philippe <philippe.deniel@CEA.FR>
MIME-Version: 1.0
Subject: Question : Using libhandle from xfsprogs and xfs actions made "by
	handle"
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

I had a look at the stuff within xfsprogs and it really look pretty 
nice. One thing is of great interest to me : the libhandle.so library.
I am currently developing a NFS server running in userspace (see 
http://nfs-ganesha.sourceforge.net for details). As you know, the NFS 
protocol has a "handle based" semantics in the way it manages FS 
objects. All objects are identified by a unique filehandle or by their 
name and the parent's directory filehandle. The trouble is that libC 
does not include such "by handle" calls to manage FS, only the old 
fashioned POSIX API which is a "By path" API.
When looking at XFS, I saw there was "open_by_handle" and 
"path_to_handle" calls. This sounds very very good to me : this sounds 
like kind of bridge to build a handle-based API to address XFS. But so 
far, I am a bit stuck : for exporting XFS through my NFS server, I would 
need to do "by handle" everything that can be done through POSIX calls, 
open/read/write/close files, create files/directories/symlinks, erasing 
or moving files... and so on. I do not know if this is possible with the 
calls in libhandle.so. But if I had such handle based tools, I think I 
could make a nice NFS server on top of XFS (I did this kind of port for 
LUSTRE (which has a full handle based API) in my NFS server and I had 
really good performances). Can someone provide me with information about 
this ?

    Regards

       Philippe

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
