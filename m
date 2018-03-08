Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:39190 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752043AbeCHS1r (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 8 Mar 2018 13:27:47 -0500
Subject: Re: [PATCH 1/7] xfs_scrub: log operational messages when interactive
References: <151787293446.3743.11110014829952400444.stgit@magnolia>
 <151787294062.3743.16150442240772340999.stgit@magnolia>
 <d32e8c99-5a56-6409-ec42-aea01220e2f7@sandeen.net>
 <20180308180723.GZ18989@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <8694acb0-e6d9-6c5c-9db3-859b5f6e8fbe@sandeen.net>
Date: Thu, 8 Mar 2018 12:27:45 -0600
MIME-Version: 1.0
In-Reply-To: <20180308180723.GZ18989@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org



On 3/8/18 12:07 PM, Darrick J. Wong wrote:
> On Mon, Feb 12, 2018 at 02:47:14PM -0600, Eric Sandeen wrote:
>> On 2/5/18 5:22 PM, Darrick J. Wong wrote:
>>> From: Darrick J. Wong <darrick.wong@oracle.com>
>>>
>>> Record the output of an interactive session in the system log so that
>>> future support requests can get a better picture of what happened.
>>>
>>> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
>>
>> I really want to log things, but I'm conflicted about spamming syslog.
>> I'm wondering if a generic /var/log/xfs.log would be good, and it could
>> eventually log all xfs-related administrative actions and outcomes with
>> a libfrog library helper... I don't know how non-syslog log files are
>> handled in general, does everybody just roll their own?
>>
>> I'm inclined to leave this one out of 4.15 for now while I/we think
>> about the big picture here.
> 
> New idea: we won't flood syslog with the gory details of everything that
> happened.  Instead we syslog right after we've decided that yes we will
> check this filesystem, and syslog again at the end to report what we
> found.

Sounds good to me.

-Eric
