Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0SIBEHi167834 for <xfs@oss.sgi.com>; Fri, 28 Jan 2011 12:11:14 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6906F4D85B7
	for <xfs@oss.sgi.com>; Fri, 28 Jan 2011 10:13:39 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Tpn0xV4AOwqIhXXa for
	<xfs@oss.sgi.com>; Fri, 28 Jan 2011 10:13:39 -0800 (PST)
Message-ID: <4D43073C.1040100@redhat.com>
Date: Fri, 28 Jan 2011 13:13:16 -0500
From: Ric Wheeler <rwheeler@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/6] fs: add hole punching to fallocate
References: <1289248327-16308-1-git-send-email-josef@redhat.com>
	<20101109011222.GD2715@dastard> <20101109033038.GF3099@thunk.org>
	<20101109044242.GH2715@dastard> <20101109214147.GK3099@thunk.org>
	<20101109234049.GQ2715@dastard>
	<AANLkTimwmJ_ZoE9oAuA1WGhCgK585jDznqnc6k0=9Ntb@mail.gmail.com>
	<20110112124431.GP28803@dastard>
In-Reply-To: <20110112124431.GP28803@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Ted Ts'o <tytso@mit.edu>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, cluster-devel@redhat.com, cmm@us.ibm.com, Josef Bacik <josef@redhat.com>, joel.becker@oracle.com, linux-fsdevel@vger.kernel.org, Lawrence Greenfield <leg@google.com>, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org

On 01/12/2011 07:44 AM, Dave Chinner wrote:
> On Tue, Jan 11, 2011 at 04:13:42PM -0500, Lawrence Greenfield wrote:
>> On Tue, Nov 9, 2010 at 6:40 PM, Dave Chinner<david@fromorbit.com>  wrote:
>>> The historical reason for such behaviour existing in XFS was that in
>>> 1997 the CPU and IO latency cost of unwritten extent conversion was
>>> significant,
> .....
>
>>>> (Take for example a trusted cluster filesystem backend that checks the
>>>> object checksum before returning any data to the user; and if the
>>>> check fails the cluster file system will try to use some other replica
>>>> stored on some other server.)
>>> IOWs, all they want to do is avoid the unwritten extent conversion
>>> overhead. Time has shown that a bad security/performance tradeoff
>>> decision was made 13 years ago in XFS, so I see little reason to
>>> repeat it for ext4 today....
>> I'd make use of FALLOC_FL_EXPOSE_OLD_DATA. It's not the CPU overhead
>> of extent conversion. It's that extent conversion causes more metadata
>> operations than what you'd have otherwise,
> Yes, that's the "IO latency" part of the cost I mentioned above.
>
>> which means systems that
>> want to use O_DIRECT and make sure the data doesn't go away either
>> have to write O_DIRECT|O_DSYNC or need to call fdatasync().
> Seriously, we tell application writers _all the time_ that they
> *must* use fsync/fdatasync to guarantee their data is on stable
> storage and that they cannot rely on side-effects of filesystem or
> storage specific behaviours (like ext3 ordered mode) to do that job
> for them.
>
> You're suggesting that by introducing FALLOC_FL_EXPOSE_OLD_DATA,
> applications can rely on filesystem/storage specific behaviour to
> guarantee data is on stable storage without the use of
> fdatasync/fsync. Wht you describe is definitely storage specific,
> because volatile write caches still needs the fdatasync to issue a
> cache flush.
>
> Do you see the same conflict here that I do?
>

The very concept seems quite "non-enterprise".  I also agree that the cost of 
maintaining extra mount options (and code) for something that no sane end user 
would ever do seems to be a loss.

Why wouldn't you want to convert the punched hole to an unwritten extent?

Thanks!

Ric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
