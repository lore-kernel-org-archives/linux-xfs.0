Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 21 Oct 2008 08:10:19 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9LF90Ur028566
	for <xfs@oss.sgi.com>; Tue, 21 Oct 2008 08:09:01 -0700
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 82DED10C166D
	for <xfs@oss.sgi.com>; Tue, 21 Oct 2008 08:10:44 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com with ESMTP id EWM3bA8Tb6pKlNgu for <xfs@oss.sgi.com>; Tue, 21 Oct 2008 08:10:44 -0700 (PDT)
Message-ID: <48FDF0EF.3000807@sandeen.net>
Date: Tue, 21 Oct 2008 10:10:39 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 1/2, RFC] convert xfs_getbmap to take formatter	functions
References: <48FD0503.3090203@sandeen.net> <20081021080737.GA4193@infradead.org> <48FDD7AA.5050006@sandeen.net> <20081021133104.GA10372@infradead.org>
In-Reply-To: <20081021133104.GA10372@infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs mailing list <xfs@oss.sgi.com>

Christoph Hellwig wrote:
> On Tue, Oct 21, 2008 at 08:22:50AM -0500, Eric Sandeen wrote:
>> Christoph Hellwig wrote:
>>> On Mon, Oct 20, 2008 at 05:24:03PM -0500, Eric Sandeen wrote:
>> ...
>>
>>>>  /*
>>>> - * Fcntl interface to xfs_bmapi.
>>>> + * ioctl interface to xfs_bmapi.
>>>>   */
>>>>  /*
>>>> - * Fcntl interface to xfs_bmapi.
>>>> + * ioctl interface to xfs_bmapi.
>>>>   */
>>> Well, it will be for fiemap, too.  And the comment doesn't make much
>>> sense either.  Either remove it completely or replace it by something
>>> that makes sense.
>>>
>> well aren't XFS_IOC_GETBMAP(X) and fiemap _both_ ioctl interfaces to
>> xfs_bmapi?
> 
> Hmm, From the syscall point of view fiemap is indeed an ioctl, too.
> But then again the point of this function isn't do anything
> ioctl-related, but to allow to get a list of all extents for an inode
> and format them arbitrarily.

arright... if the comment is the only concern, I'm happy with that  ;)

-Eric
