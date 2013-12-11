Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8E4EC7FD1
	for <xfs@oss.sgi.com>; Tue, 10 Dec 2013 20:36:13 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 584A98F8039
	for <xfs@oss.sgi.com>; Tue, 10 Dec 2013 18:36:13 -0800 (PST)
Received: from mail-ob0-f170.google.com (mail-ob0-f170.google.com
	[209.85.214.170]) by cuda.sgi.com with ESMTP id
	Auu0KNFGGqhcIord (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 10 Dec 2013 18:36:12 -0800 (PST)
Received: by mail-ob0-f170.google.com with SMTP id wp18so6298192obc.15
	for <xfs@oss.sgi.com>; Tue, 10 Dec 2013 18:36:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20131209233002.GV31386@dastard>
References: <CAGXu5jLKkgYg5UWJc8xBGN5NgDh68Q3YRxO--zmDL86BWPH78A@mail.gmail.com>
	<20131209233002.GV31386@dastard>
Date: Tue, 10 Dec 2013 18:36:11 -0800
Message-ID: <CAGXu5j+u0xSN7jQk8udLefMAa5xNSNHU98as33QYHWOyv-JuJw@mail.gmail.com>
Subject: Re: XFS security fix never sent to -stable?
From: Kees Cook <keescook@google.com>
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
Cc: Greg KH <gregkh@linuxfoundation.org>, Brian Foster <bfoster@redhat.com>, Dwight Engen <dwight.engen@oracle.com>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Ben Myers <bpm@sgi.com>, Gao feng <gaofeng@cn.fujitsu.com>, Dave Chinner <dchinner@redhat.com>

On Mon, Dec 9, 2013 at 3:30 PM, Dave Chinner <david@fromorbit.com> wrote:
> [CC the xfs list. Kees - I shouldn't have to remind you to do this. ]
>
> On Thu, Dec 05, 2013 at 04:35:50PM -0800, Kees Cook wrote:
>> Hi,
>>
>> It looks like 8c567a7fab6e086a0284eee2db82348521e7120c ("xfs: add
>> capability check to free eofblocks ioctl") is a security fix that was
>> never sent to -stable? From what I can see, it was introduced in 3.8
>> by 8ca149de80478441352a8622ea15fae7de703ced ("xfs: add
>> XFS_IOC_FREE_EOFBLOCKS ioctl").
>>
>> I don't see this in the 3.8.y tree. Should it be added there and newer?
>
> Well, it's not really a security problem at all, given that it only
> affects speculative preallocation beyond EOF. i.e. it affects
> filesystem metadata that does not yet index any user data.
>
> Indeed, the kernel already does exactly what this ioctl does every 5
> minutes without user intervention. i.e. it's simply a maintenance
> task we need to execute periodically or on demand as a result of
> other events (e.g. from a userspace daemon that is listen to quota
> exhaustion messages).
>
> So apart from allowing a user to burn some CPU with the ioctl doing
> nothing but scanning, there's little in way of a security problem
> being exposed on kernels prior to 3.12 here.
>
> The reason for the cap check? Turning off this ioctl in containers
> restricted by user name spaces. i.e. new functionality added to XFS
> in 3.12 introduced curiously vague and difficult to explain new
> inode access restrictions, so we took the "be safe by default" route
> and only allowed the init namespace access to the ioctl....

Right, it wasn't clear from the commit, and it looked troublesome, but
it's function wasn't obvious, so that's why I asked.

-Kees

-- 
Kees Cook
Chrome OS Security

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
