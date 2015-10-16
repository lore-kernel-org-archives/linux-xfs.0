Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A29377F85
	for <xfs@oss.sgi.com>; Fri, 16 Oct 2015 11:13:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 836BE8F804C
	for <xfs@oss.sgi.com>; Fri, 16 Oct 2015 09:13:22 -0700 (PDT)
Received: from mail-lb0-f173.google.com (mail-lb0-f173.google.com
	[209.85.217.173]) by cuda.sgi.com with ESMTP id
	hjQ5YtGcWh6xFfvd (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 16 Oct 2015 09:13:20 -0700 (PDT)
Received: by lbbes7 with SMTP id es7so14264223lbb.2
	for <xfs@oss.sgi.com>; Fri, 16 Oct 2015 09:13:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALCETrXFkB01tk21FuEOqABHWg1XyOQwsT+s=Lq0RYye6X_7xw@mail.gmail.com>
References: <1445008706-15115-1-git-send-email-agruenba@redhat.com>
	<1445008706-15115-17-git-send-email-agruenba@redhat.com>
	<CALCETrXFkB01tk21FuEOqABHWg1XyOQwsT+s=Lq0RYye6X_7xw@mail.gmail.com>
Date: Fri, 16 Oct 2015 18:13:19 +0200
Message-ID: <CAHc6FU7SNs6+xt34s18xM-C4U_7v5DLcN_feHXhVMY1q=K6zxA@mail.gmail.com>
Subject: Re: [PATCH v11 16/48] richacl: Automatic Inheritance
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
To: Andy Lutomirski <luto@amacapital.net>
Cc: linux-cifs@vger.kernel.org, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, Linux API <linux-api@vger.kernel.org>, Trond Myklebust <trond.myklebust@primarydata.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, "J. Bruce Fields" <bfields@fieldses.org>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, Anna Schumaker <anna.schumaker@netapp.com>

On Fri, Oct 16, 2015 at 6:00 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Fri, Oct 16, 2015 at 8:17 AM, Andreas Gruenbacher
> <agruenba@redhat.com> wrote:
>> Automatic Inheritance works as follows:
>>
>>  - When the RICHACL_AUTO_INHERIT flag in the acl of a file or directory
>>    is not set, the file or directory is not affected by AI.
>>
>>  - When the RICHACL_AUTO_INHERIT flag in the acl of a directory is set
>>    and a file or subdirectory is created in that directory, the
>>    inherited acl will have the RICHACL_AUTO_INHERIT flag set, and all
>>    inherited aces will have the RICHACE_INHERITED_ACE flag set.  This
>>    allows user space to distinguish between aces which have been
>>    inherited and aces which have been explicitly added.
>
> What if the file or subdirectory that's created in that directory is a
> hard link?

Directories cannot have hard links.

When a file is hard linked into multiple directories with different
inheritable permissions, the permissions set last will "win". This
isn't particularly pretty, but it's the way this has worked on that
other operating system with significant marked share for the last
fifteen years.

Thanks,
Andreas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
