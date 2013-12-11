Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 344037FD4
	for <xfs@oss.sgi.com>; Tue, 10 Dec 2013 20:46:00 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D4A4AAC00B
	for <xfs@oss.sgi.com>; Tue, 10 Dec 2013 18:45:56 -0800 (PST)
Received: from mail-oa0-f44.google.com (mail-oa0-f44.google.com
	[209.85.219.44]) by cuda.sgi.com with ESMTP id zlQGhDcyykeokmWW
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 10 Dec 2013 18:45:55 -0800 (PST)
Received: by mail-oa0-f44.google.com with SMTP id m1so6634646oag.31
	for <xfs@oss.sgi.com>; Tue, 10 Dec 2013 18:45:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20131211020007.GH10988@dastard>
References: <CAGXu5jLKkgYg5UWJc8xBGN5NgDh68Q3YRxO--zmDL86BWPH78A@mail.gmail.com>
	<20131209121534.GE4278@hercules>
	<CA+5PVA4ychvLEi1ZZ6rYy2=5-wZAbQ_a-aoy8=1w3+tr-pt3Fg@mail.gmail.com>
	<20131209235523.GW31386@dastard>
	<CA+5PVA5rUmWYQiPwkN15CnfqckmEjVukXz3mU75CiUBVzfERqA@mail.gmail.com>
	<20131211010326.GF10988@dastard>
	<CA+5PVA7wso5fo11xX9kCUdbrqBQMzUnYwTOB_Qe3K7LDY4z_Cw@mail.gmail.com>
	<20131211020007.GH10988@dastard>
Date: Tue, 10 Dec 2013 18:45:54 -0800
Message-ID: <CAGXu5jKUShtztTK-PtY7w0WSg=F3KUGL-iCM3=6H61qy3u6aZg@mail.gmail.com>
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
Cc: Josh Boyer <jwboyer@fedoraproject.org>, Luis Henriques <luis.henriques@canonical.com>, Greg KH <gregkh@linuxfoundation.org>, Brian Foster <bfoster@redhat.com>, Dwight Engen <dwight.engen@oracle.com>, LKML <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, xfs@oss.sgi.com, Ben Myers <bpm@sgi.com>, Gao feng <gaofeng@cn.fujitsu.com>, Dave Chinner <dchinner@redhat.com>, Dan Carpenter <dan.carpenter@oracle.com>

On Tue, Dec 10, 2013 at 6:00 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Tue, Dec 10, 2013 at 08:10:51PM -0500, Josh Boyer wrote:
>> On Tue, Dec 10, 2013 at 8:03 PM, Dave Chinner <david@fromorbit.com> wrote:
>> > Security processes are not something that should be hidden away in
>> > it's own private corner - if there's a problem upstream needs to
>> > take action on, then direct contact with upstream is necessary. We
>> > need to know about security issues - even ones that are classified
>> > post-commit as security issues - so we are operating with full
>> > knowledge of the issues in our code and the impact of our fixes....
>>
>> Agreed.  I'm going to interpret your comments at being directed to the
>> general audience because otherwise you're just shooting the messenger
>> :).
>
> Right, they are not aimed at you - they are aimed at those on the
> security side of the fence. I'm tired of learning about CVEs in XFS
> code through chinese whispers and/or luck.

Mostly I try to shield anyone not interested in CVEs from the boring
process, and try to focus on just getting things marked as needing to
go into stable. I don't think anyone needs to read the oss-security
list if they don't want to.

In this case, the fix Dan sent was part of a larger collection of
security issues reported by Nico. I think the communication error here
was Dan accidentally forgetting to add the Cc: stable tag. But beyond
that, it was sent to the xfs list and Cc: to security, so I'm not sure
it's fair to say it was hidden away. :)

Besides the missing Cc: stable tag, what should future patch senders
do to call attention to an issue being a security problem at the time
it is being reported?

-Kees

-- 
Kees Cook
Chrome OS Security

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
