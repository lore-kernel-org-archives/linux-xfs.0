Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 95ECA7F53
	for <xfs@oss.sgi.com>; Fri, 23 Oct 2015 15:05:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 853EC30404E
	for <xfs@oss.sgi.com>; Fri, 23 Oct 2015 13:05:21 -0700 (PDT)
Received: from elasmtp-dupuy.atl.sa.earthlink.net
	(elasmtp-dupuy.atl.sa.earthlink.net [209.86.89.62]) by
	cuda.sgi.com with ESMTP id LpD5ETgQgEDGNzjJ for
	<xfs@oss.sgi.com>; Fri, 23 Oct 2015 13:05:16 -0700 (PDT)
From: "Frank Filz" <ffilzlnx@mindspring.com>
References: <1445625722-13791-1-git-send-email-agruenba@redhat.com>
In-Reply-To: <1445625722-13791-1-git-send-email-agruenba@redhat.com>
Subject: RE: [PATCH v12 00/49] Richacls
Date: Fri, 23 Oct 2015 13:03:59 -0700
Message-ID: <002f01d10dcd$f5f9f170$e1edd450$@mindspring.com>
MIME-Version: 1.0
Content-Language: en-us
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: 'Andreas Gruenbacher' <agruenba@redhat.com>, 'Alexander Viro' <viro@zeniv.linux.org.uk>, 'Theodore Ts'o' <tytso@mit.edu>, 'Andreas Dilger' <adilger.kernel@dilger.ca>, "'J. Bruce Fields'" <bfields@fieldses.org>, 'Jeff Layton' <jlayton@poochiereds.net>, 'Trond Myklebust' <trond.myklebust@primarydata.com>, 'Anna Schumaker' <anna.schumaker@netapp.com>, 'Dave Chinner' <david@fromorbit.com>, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, linux-api@vger.kernel.org

Andreas Gruenbacher:
> 
> Here is another update of the richacl patch queue.  I would like to ask
for
> feedback so that the core and local filesystem code (patches 1-25) can be
> merged in the 4.4 merge window.
> 
> Changes since the last posting (http://lwn.net/Articles/661078/):
> 
>  * On ext4, filesystems with the richacl feature can no longer be mounted
>    with -o noacl; richacls cannot be turned off.
> 
>  * XFS was listing richacl xattrs as "trusted.system.richacl"; this has
>    been fixed.
> 
>  * Some definitions have been moved from include/linux/ to
>    include/uapi/linux/.  The license of the uapi headers has been changed
>    to LGPL.

Thanks for that last. I kept meaning to ask about that for cleaner use in
Ganesha.

Frank



---
This email has been checked for viruses by Avast antivirus software.
https://www.avast.com/antivirus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
