Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C573F7F37
	for <xfs@oss.sgi.com>; Tue, 27 Oct 2015 05:56:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8BCB6304032
	for <xfs@oss.sgi.com>; Tue, 27 Oct 2015 03:56:51 -0700 (PDT)
Received: from mail-lb0-f175.google.com (mail-lb0-f175.google.com
	[209.85.217.175]) by cuda.sgi.com with ESMTP id
	WlqyCbMagazvCZaD (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 27 Oct 2015 03:56:48 -0700 (PDT)
Received: by lbbwb3 with SMTP id wb3so60377074lbb.1
	for <xfs@oss.sgi.com>; Tue, 27 Oct 2015 03:56:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20151027053045.GL8773@dastard>
References: <CAHc6FU5gS4BA+iTRHo1oHJMVHkLs4aa0eYd5T1ftLC9biRaxrg@mail.gmail.com>
	<20151024125659.GA8095@bfoster.bfoster>
	<CAHc6FU6eVn=KpKvhD2N8hvAgdFQVdBHHS9tUgaVQJf5wnipY=g@mail.gmail.com>
	<20151024152254.GA22232@bfoster.bfoster>
	<20151026213228.GI8773@dastard>
	<CAHc6FU68MYTGWKM5S14_dQBqXeebd2GwQcKj4RztLvPWL2eksA@mail.gmail.com>
	<20151027053045.GL8773@dastard>
Date: Tue, 27 Oct 2015 11:56:46 +0100
Message-ID: <CAHc6FU4ZgJDKphScucvDfEWPFFu4dGfDVund9Wrah=X-vxnz3w@mail.gmail.com>
Subject: Re: Inconsistencies with trusted.SGI_ACL_{FILE,DEFAULT}
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
To: Dave Chinner <david@fromorbit.com>
Cc: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On Tue, Oct 27, 2015 at 6:30 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Tue, Oct 27, 2015 at 12:52:10AM +0100, Andreas Gruenbacher wrote:
>> On Mon, Oct 26, 2015 at 10:32 PM, Dave Chinner <david@fromorbit.com> wrote:
>> > Really, I'm struggling to understand what the problem is with XFS
>> > doing translation to it's own special xattr names for ACLs
>> > underneath the posix layer.
>>
>> Right now, setting one of the SGI_ACL attributes leads to stale i_acl
>> / i_default_acl fields and in the case of SGI_ACL_FILE, possibly to
>> outdated permissions in i_mode. You would get different information
>> from getfacl than what's stored on disk.
>
> That's because we're not marking the cached acl as stale when
> setting the acl directly...
>
>> > Yes, there's a caching issue when someone directly manipulates
>> > the underlying xattr,
>>
>> "Directly manipulating" could be doing a setxattr of an attribute that
>> was previously retrieved by getxattr, like restoring a backup.
>
> Sure, that's what xfsdump/restore effectively does.
>
>> > but you need root to shoot yourself in the foot that way, and that is easily
>> > solveable.
>>
>> What do you mean, it's easily solvable?
>
> forget_all_cached_acls()

Brian has already suggested that in this thread. Still leaves the
i_mode permission bits stale and is broken wrt. uid/gid namespaces.

Andreas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
