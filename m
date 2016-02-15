Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EA13D7CA2
	for <xfs@oss.sgi.com>; Mon, 15 Feb 2016 04:25:22 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BDF588F8049
	for <xfs@oss.sgi.com>; Mon, 15 Feb 2016 02:25:22 -0800 (PST)
Received: from mail-wm0-f45.google.com (mail-wm0-f45.google.com
	[74.125.82.45]) by cuda.sgi.com with ESMTP id N8lJudfiZcyfC1VX
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 15 Feb 2016 02:25:18 -0800 (PST)
Received: by mail-wm0-f45.google.com with SMTP id g62so142531207wme.0
	for <xfs@oss.sgi.com>; Mon, 15 Feb 2016 02:25:18 -0800 (PST)
Subject: Re: richacl(7) man page review comments
References: <56B770B6.7040803@gmail.com> <56B77262.7090107@gmail.com>
	<CAHc6FU5__xbKm4mg8+fK_ZW5ZYsDoQcYBBvQg573Eq4ERDsROw@mail.gmail.com>
	<56C0F150.60008@gmail.com>
	<CAHc6FU49uRb11HhO655jimn_CzLrDyGHAB2iDAv92cftCCXkEA@mail.gmail.com>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Message-ID: <56C1A788.9020008@gmail.com>
Date: Mon, 15 Feb 2016 11:25:12 +0100
MIME-Version: 1.0
In-Reply-To: <CAHc6FU49uRb11HhO655jimn_CzLrDyGHAB2iDAv92cftCCXkEA@mail.gmail.com>
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
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Andreas Dilger <adilger@dilger.ca>, linux-cifs@vger.kernel.org, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Linux API <linux-api@vger.kernel.org>, Trond Myklebust <trond.myklebust@primarydata.com>, lkml <linux-kernel@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>, "J. Bruce Fields" <bfields@fieldses.org>, mtk.manpages@gmail.com, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>, linux-ext4 <linux-ext4@vger.kernel.org>, Anna Schumaker <anna.schumaker@netapp.com>

Hi Andreas,

On 02/15/2016 12:12 AM, Andreas Gruenbacher wrote:
> On Sun, Feb 14, 2016 at 10:27 PM, Michael Kerrisk (man-pages)
> <mtk.manpages@gmail.com> wrote:
>> On 02/12/2016 11:25 PM, Andreas Gruenbacher wrote:
>>> We could sure move acl(5) and richacl(7) there.
>>
>> We already have acl(5) (now "acl(7)" in man pages) ;-).
> 
> Hmm, I can't find that page either in
> git://git.kernel.org/pub/scm/docs/man-pages/man-pages or on
> http://man7.org/. Are you sure you don't mean xattr.7 == attr.5 which
> documents the xattr syscall interface?

You're right. I was confusing with xattr(7). So, I think it might
make some sense to eventually move both of these into man-pages (for 
richacl(7), at least, it's probably worth delaying this for a bit), 
since  they're describing kernel-user-space interfaces. I can see 
counter-arguments too, such as these pages are closely related to 
the corresponding user-space libraries you maintain. What do you
think?

Thanks,

Michael



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
