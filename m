Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4CFbYbu170643 for <xfs@oss.sgi.com>; Wed, 12 May 2010 10:37:34 -0500
Received: from oxalide-out.extra.cea.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B06901DEE2D9
	for <xfs@oss.sgi.com>; Wed, 12 May 2010 08:39:46 -0700 (PDT)
Received: from oxalide-out.extra.cea.fr (oxalide-out.extra.cea.fr
	[132.168.224.1]) by cuda.sgi.com with ESMTP id HPPzNM2DwoSiNho2
	for <xfs@oss.sgi.com>; Wed, 12 May 2010 08:39:46 -0700 (PDT)
Received: from pisaure.intra.cea.fr (pisaure.intra.cea.fr [132.166.88.21])
	by oxalide.extra.cea.fr (8.14.2/8.14.2/CEAnet-Internet-out-2.0) with
	ESMTP id o4CFdjwr010362
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <xfs@oss.sgi.com>; Wed, 12 May 2010 17:39:45 +0200
Received: from muguet1.intra.cea.fr (muguet1.intra.cea.fr [132.166.192.6])
	by pisaure.intra.cea.fr (8.14.4/8.14.4) with ESMTP id o4CFdjYj016442
	for <xfs@oss.sgi.com>; Wed, 12 May 2010 17:39:45 +0200
	(envelope-from Philippe.DENIEL@CEA.FR)
Received: from zia.bruyeres.cea.fr (esteban.dam.intra.cea.fr [132.165.76.10])
	by muguet1.intra.cea.fr (8.13.8/8.13.8/CEAnet-Intranet-out-1.1) with
	SMTP id o4CFdjL8018499
	for <xfs@oss.sgi.com>; Wed, 12 May 2010 17:39:45 +0200
Message-ID: <4BEACBC0.3080300@cea.fr>
Date: Wed, 12 May 2010 17:39:44 +0200
From: DENIEL Philippe <philippe.deniel@CEA.FR>
MIME-Version: 1.0
Subject: open_by_handle on a file ?
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

I start using libhandle.so from xfsprogs-3.0.3 package. I meet an issue 
here : I can get a handle from files or directory.
When used on diretories, open_by_handle works fine : I can read entries 
in it by using getdents, create stuff / removing stuff by using the 
ATFILE_FUNCTION (mkdirat, renameat, ...)

Trouble start when I want to open a file with open_by_handle. I have a 
small test program that does this :

        rc = path_to_fshandle( path_dir,  (void **)(&fshandle),
    &fshandlelen) ;
      if( rc < 0 ) exit( -1)
        
      rc = path_to_handle( path_dir,  (void **)(&filehandle), &handlelen) ;
      if( rc < 0 ) exit( -1 )

      fd = open_by_handle( filehandle, handlelen, O_RDONLY ) ;
      printf( "open_by_handle: fd=%d \n", fd ) ;
      if( fd < 0 )
           printf( "----> Error=%d | %s\n", errno, strerror( errno ) ) ;

The open_by_handle failed with errno=20 aka ENOTDIR, which is true, this 
is a file and no directory.
Question is : Can I use open_by_handle to open a regular file ? If yes, 
how should I proceed. If no, how should I do to open a file knowing its 
handle ?

    Thanks in advance for your time and answer.

       Regards

          Philippe


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
