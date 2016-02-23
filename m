Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 00E117F53
	for <xfs@oss.sgi.com>; Tue, 23 Feb 2016 04:27:37 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B3164304043
	for <xfs@oss.sgi.com>; Tue, 23 Feb 2016 02:27:30 -0800 (PST)
Received: from mail-wm0-f51.google.com (mail-wm0-f51.google.com
	[74.125.82.51]) by cuda.sgi.com with ESMTP id 8hOqUWaTP7ENFsFY
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 23 Feb 2016 02:16:30 -0800 (PST)
Received: by mail-wm0-f51.google.com with SMTP id g62so214093153wme.1
	for <xfs@oss.sgi.com>; Tue, 23 Feb 2016 02:16:30 -0800 (PST)
Subject: Re: richacl(7) man page review comments
References: <56B770B6.7040803@gmail.com> <56B77262.7090107@gmail.com>
	<CAHc6FU5__xbKm4mg8+fK_ZW5ZYsDoQcYBBvQg573Eq4ERDsROw@mail.gmail.com>
	<56C0F23C.7030902@gmail.com>
	<CAHc6FU4CCrcrA6=oCiq2A5rGd9CCGELaTZq6tGpmd2jcV_Zp4A@mail.gmail.com>
	<56CA2EEB.9080504@gmail.com>
	<CAHc6FU46vO8NM3cvFH7b8X7U9R+m6wcYj8EQKVnSQkiY3Q051A@mail.gmail.com>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Message-ID: <56CC3174.2060207@gmail.com>
Date: Tue, 23 Feb 2016 11:16:20 +0100
MIME-Version: 1.0
In-Reply-To: <CAHc6FU46vO8NM3cvFH7b8X7U9R+m6wcYj8EQKVnSQkiY3Q051A@mail.gmail.com>
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

On 02/22/2016 03:46 PM, Andreas Gruenbacher wrote:
> Hi Michael,
> 
> On Sun, Feb 21, 2016 at 10:40 PM, Michael Kerrisk (man-pages)
> <mtk.manpages@gmail.com> wrote:
>> I've once more pulled from the latest git; here's some more comments.
> 
> thanks again. I've updated the repo with your changes.

Thanks!

[...]

>> I'm going to play the broken record :-)
>>
>> Could we start with just a few simple examples already, and build up
>> over future iterations of this page?
> 
> Yes, as soon as I'll get to it :)

Sure. But, to press the point home, I'm interested to do further
review, but I feel like the lack of examples is limiting my ability to
understand what's going on and deepen the feedback that I provide in
future iterations. So, start please, even if only starting small :-).

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
