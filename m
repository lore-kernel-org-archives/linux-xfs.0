Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4D9827CB9
	for <xfs@oss.sgi.com>; Sun, 21 Feb 2016 15:18:49 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B300FAC00D
	for <xfs@oss.sgi.com>; Sun, 21 Feb 2016 13:18:42 -0800 (PST)
Received: from mail-wm0-f53.google.com (mail-wm0-f53.google.com
	[74.125.82.53]) by cuda.sgi.com with ESMTP id IcDQh94Y2lk706VV
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 21 Feb 2016 13:01:31 -0800 (PST)
Received: by mail-wm0-f53.google.com with SMTP id g62so133011673wme.0
	for <xfs@oss.sgi.com>; Sun, 21 Feb 2016 13:01:31 -0800 (PST)
Subject: Re: richacl(7) man page review comments
References: <56B770B6.7040803@gmail.com> <56B77262.7090107@gmail.com>
	<CAHc6FU5__xbKm4mg8+fK_ZW5ZYsDoQcYBBvQg573Eq4ERDsROw@mail.gmail.com>
	<56C0F23C.7030902@gmail.com>
	<CAHc6FU4CCrcrA6=oCiq2A5rGd9CCGELaTZq6tGpmd2jcV_Zp4A@mail.gmail.com>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Message-ID: <56CA25A5.2030100@gmail.com>
Date: Sun, 21 Feb 2016 22:01:25 +0100
MIME-Version: 1.0
In-Reply-To: <CAHc6FU4CCrcrA6=oCiq2A5rGd9CCGELaTZq6tGpmd2jcV_Zp4A@mail.gmail.com>
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

On 02/20/2016 05:37 PM, Andreas Gruenbacher wrote:
> Hi Michael,
> 
> thanks again for all the feedback. I've followed all your suggestions;
> again, please see the github repo for the latest version:
> 
>   https://github.com/andreas-gruenbacher/richacl
> 
> On Sun, Feb 14, 2016 at 10:31 PM, Michael Kerrisk (man-pages)
> <mtk.manpages@gmail.com> wrote:
>> Hi Andreas,
>>
>> Here's a few more comments on the current richacl(7) page
>> that I fetched from the git repo.
>>

[...]

>>> .HP
>>> .BR dir_inherit "\ (" d ):
>>> The entry is inheritable for directories.
>>
>> "When this flag appears in the ACL entry of a directory, then that entry is
>> inherited by new subdirectories created in the directory."
>>
>> Is that text that I propose correct?
> 
> It's not entirely wrong, but only a small part of the truth. Entries
> are inherited such that the permissions in file_inherit entries become
> effective for access checking for new files, and the permissions in
> dir_inherit entries become effective for access checking for new
> directories, recursively.
> 
> Your feedback prompted me to look into the inheritance flag
> computation more closely once again, and I found bugs. The steps of
> the algorithm are explained in the section "Permissions at
> file-creation time", by the way.

Hmmm... writing and refining documentation helps find code bugs. 
Who knew? :-)

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
