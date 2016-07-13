Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 455417CA6
	for <xfs@oss.sgi.com>; Wed, 13 Jul 2016 14:40:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D1433AC002
	for <xfs@oss.sgi.com>; Wed, 13 Jul 2016 12:40:28 -0700 (PDT)
Received: from elasmtp-junco.atl.sa.earthlink.net
	(elasmtp-junco.atl.sa.earthlink.net [209.86.89.63]) by
	cuda.sgi.com with ESMTP id vMOoEiHyQ2Jd4FKV (version=TLSv1
	cipher=DHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 13 Jul 2016 12:40:26 -0700 (PDT)
From: "Frank Filz" <ffilzlnx@mindspring.com>
References: <1467294433-3222-1-git-send-email-agruenba@redhat.com>
	<1467294433-3222-9-git-send-email-agruenba@redhat.com>
	<1467728537.3800.32.camel@redhat.com>
	<014101d1d6df$e059fd20$a10df760$@mindspring.com>
	<CAHc6FU5oeaCxgZPFeNSHDfSjnVKe9km14R4s5RoBhJXPaL7ymQ@mail.gmail.com>
In-Reply-To: <CAHc6FU5oeaCxgZPFeNSHDfSjnVKe9km14R4s5RoBhJXPaL7ymQ@mail.gmail.com>
Subject: RE: [PATCH v23 08/22] richacl: Compute maximum file masks from an acl
Date: Wed, 13 Jul 2016 12:38:50 -0700
Message-ID: <018b01d1dd3e$2f868170$8e938450$@mindspring.com>
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
To: 'Andreas Gruenbacher' <agruenba@redhat.com>
Cc: "'J. Bruce Fields'" <bfields@fieldses.org>, 'Linux NFS Mailing List' <linux-nfs@vger.kernel.org>, 'Theodore Ts'o' <tytso@mit.edu>, 'Jeff Layton' <jlayton@redhat.com>, linux-cifs@vger.kernel.org, 'Linux API' <linux-api@vger.kernel.org>, 'Trond Myklebust' <trond.myklebust@primarydata.com>, 'LKML' <linux-kernel@vger.kernel.org>, 'XFS Developers' <xfs@oss.sgi.com>, 'Christoph Hellwig' <hch@infradead.org>, 'Andreas Dilger' <adilger.kernel@dilger.ca>, 'Alexander Viro' <viro@zeniv.linux.org.uk>, 'linux-fsdevel' <linux-fsdevel@vger.kernel.org>, 'linux-ext4' <linux-ext4@vger.kernel.org>, 'Anna Schumaker' <anna.schumaker@netapp.com>

> > Hmm, but does that result in examining the whole ACL for most access
> checks, at least for files where most of the accesses are by the owner, or a
> member of a specific group (with perhaps a ton of special case users added
> on the end)?
> 
> I don't understand -- what does this algorithm have to do with access checks?

Oh, sorry, misread the patch... got caught up looking at a tree and not seeing the forest...

Frank



---
This email has been checked for viruses by Avast antivirus software.
https://www.avast.com/antivirus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
