Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2C9bmVO051170 for <xfs@oss.sgi.com>; Mon, 12 Mar 2012 04:37:49 -0500
Message-ID: <4F5DC396.60701@parallels.com>
Date: Mon, 12 Mar 2012 13:36:22 +0400
From: Glauber Costa <glommer@parallels.com>
MIME-Version: 1.0
Subject: Re: [RFC PATCH v1 0/4] cgroup quota
References: <4F59E78A.7060903@oracle.com> <4F5C933F.3000409@parallels.com>
	<4F5C90DF.8070605@oracle.com>
In-Reply-To: <4F5C90DF.8070605@oracle.com>
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
To: jeff.liu@oracle.com
Cc: jack@suse.cz, Lezcano <daniel.lezcano@free.fr>, lxc-devel@lists.sourceforge.net, Li Zefan <lizf@cn.fujitsu.com>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Ben Myers <bpm@sgi.com>, tytso@MIT.EDU, Chris Mason <chris.mason@oracle.com>, Christopher Jones <christopher.jones@oracle.com>, tj@kernel.org, cgroups@vger.kernel.org, Daniel@oss.sgi.com

On 03/11/2012 03:47 PM, Jeff Liu wrote:
> And also, if there has already a project quota limits enforced outsides
> to a directly, but the user can still setup a smaller quota limit s
> through cgroup ,those limits just mixed up, but the smaller quota only
> be effected for those processes running at container.
>
>> >
>> >  What we really need here, is a way to have a privileged user inside a
>> >  container to create normal quotas (user, group) that he can configure,
>> >  and have this quota be always smaller than, say, a project quota defined
>> >  for the container from the outside. But cgroups is hardly the interface,
>> >  or place, for that: Usually, the processes inside the container won't
>> >  have access to their cgroups. They will contain the limits they are
>> >  entitled to, and we don't won't the processes to change that at will. So
>> >  tying it to cgroups does not solve the fundamental problem, which is how
>> >  we have the container admin to set up quotas...
> Sigh, exactly, I need some time to understand your opinions.  Thanks again.
>
>

My take on this is that you should stick to the quota interface. It 
seems to works well enough for people out there. This means, how quotas 
are configured, viewed, etc, should work with standard tools.

Now, we need some of those quotas to be tied to a particular mnt 
namespace (I believe namespaces to be the right isolation abstraction 
here, not cgroups), in the sense that they can only be active inside 
that mnt namespace. And then when you bill an inode, block, or anything 
else that quota limits, you bill it to any quota structure that is 
possibly interested in it. Right now the code bills it to one quota 
structure, the one that matches your UID, GID, etc (XFS may be a bit 
more skilled already here, I don't know)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
