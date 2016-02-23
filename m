Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 02CEA7F8C
	for <xfs@oss.sgi.com>; Tue, 23 Feb 2016 05:28:51 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 57F94AC002
	for <xfs@oss.sgi.com>; Tue, 23 Feb 2016 03:28:44 -0800 (PST)
Received: from mail-vk0-f47.google.com (mail-vk0-f47.google.com
	[209.85.213.47]) by cuda.sgi.com with ESMTP id DPaunhWrhDMk8YqJ
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 23 Feb 2016 03:14:36 -0800 (PST)
Received: by mail-vk0-f47.google.com with SMTP id e6so157591731vkh.2
	for <xfs@oss.sgi.com>; Tue, 23 Feb 2016 03:14:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56CC3B4A.7070204@gmail.com>
References: <56B770B6.7040803@gmail.com> <56B77262.7090107@gmail.com>
	<CAHc6FU5__xbKm4mg8+fK_ZW5ZYsDoQcYBBvQg573Eq4ERDsROw@mail.gmail.com>
	<56C0F23C.7030902@gmail.com>
	<CAHc6FU4CCrcrA6=oCiq2A5rGd9CCGELaTZq6tGpmd2jcV_Zp4A@mail.gmail.com>
	<56CA2EEB.9080504@gmail.com>
	<CAHc6FU46vO8NM3cvFH7b8X7U9R+m6wcYj8EQKVnSQkiY3Q051A@mail.gmail.com>
	<56CC3B4A.7070204@gmail.com>
Date: Tue, 23 Feb 2016 12:14:35 +0100
Message-ID: <CAHc6FU4dSsqVBJsN3jCAPrEtX5beiJ9Km_g=r53kJ+8iQPOSUA@mail.gmail.com>
Subject: Re: richacl(7) man page review comments
From: Andreas Gruenbacher <agruenba@redhat.com>
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
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Andreas Dilger <adilger@dilger.ca>, linux-cifs@vger.kernel.org, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Linux API <linux-api@vger.kernel.org>, Trond Myklebust <trond.myklebust@primarydata.com>, lkml <linux-kernel@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>, "J. Bruce Fields" <bfields@fieldses.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>, linux-ext4 <linux-ext4@vger.kernel.org>, Anna Schumaker <anna.schumaker@netapp.com>

On Tue, Feb 23, 2016 at 11:58 AM, Michael Kerrisk (man-pages)
<mtk.manpages@gmail.com> wrote:
> So, in terms of actually testing this stuff, is it just a matter of
> applying your patch series to the kernel, building the kernel, pulling
> the RichACL user-space tools from Git, and mount(8)ing a filesystem with
> the right option?

You'd create a test filesystem with the appropriate feature flag set
(mkfs.ext4 -O richacl2 / mkfs.xfs -m richacl=1), RichACLs are not
enabled by mount options anymore. This will obviously require versions
of e2fsprogs / xfsprogs that understand the feature. If you want
coreutils support which isn't strictly necessary, you'll need the
patched version too. Other than that, it's really simple.

Andreas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
