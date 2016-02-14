Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EF8DC7CA2
	for <xfs@oss.sgi.com>; Sun, 14 Feb 2016 15:27:56 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C4CDC8F8039
	for <xfs@oss.sgi.com>; Sun, 14 Feb 2016 13:27:53 -0800 (PST)
Received: from mail-wm0-f52.google.com (mail-wm0-f52.google.com
	[74.125.82.52]) by cuda.sgi.com with ESMTP id WDq2tLsfIy303Nwk
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 14 Feb 2016 13:27:51 -0800 (PST)
Received: by mail-wm0-f52.google.com with SMTP id g62so33608226wme.1
	for <xfs@oss.sgi.com>; Sun, 14 Feb 2016 13:27:51 -0800 (PST)
Subject: Re: richacl(7) man page review comments
References: <56B770B6.7040803@gmail.com> <56B77262.7090107@gmail.com>
	<CAHc6FU5__xbKm4mg8+fK_ZW5ZYsDoQcYBBvQg573Eq4ERDsROw@mail.gmail.com>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Message-ID: <56C0F150.60008@gmail.com>
Date: Sun, 14 Feb 2016 22:27:44 +0100
MIME-Version: 1.0
In-Reply-To: <CAHc6FU5__xbKm4mg8+fK_ZW5ZYsDoQcYBBvQg573Eq4ERDsROw@mail.gmail.com>
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

On 02/12/2016 11:25 PM, Andreas Gruenbacher wrote:
> Hi Michael,
> 
> On Sun, Feb 7, 2016 at 5:35 PM, Michael Kerrisk (man-pages)
> <mtk.manpages@gmail.com> wrote:
>> Hi Andreas,
>>
>> I'll probably have quite a few more comments on this page as I get to
>> understand RichACLs better. Here's some comments from an initial
>> reading.
> 
> thanks a lot for all the feedback to the man-pages. I've more or less
> made all the suggested changes but didn't get to adding examples yet
> (that's not so easy).
> 
> The changes are here:
> 
>   https://github.com/andreas-gruenbacher/richacl

Thanks. I'll send a few further comments. But I hope to send
more in the future.

>> So, an initial comment. It seems to me to that this page (but
>> not setrichacl(1) and getrichacl(1)) should ultimately land in
>> man-pages (just like acl(7)), since we're talking about a kernel
>> feature. Make sense?
> 
> We could sure move acl(5) and richacl(7) there.

We already have acl(5) (now "acl(7)" in man pages) ;-).

Cheers,

Michael



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
