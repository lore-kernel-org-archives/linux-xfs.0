Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B42587F51
	for <xfs@oss.sgi.com>; Fri, 14 Feb 2014 10:41:19 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 446ABAC001
	for <xfs@oss.sgi.com>; Fri, 14 Feb 2014 08:41:18 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id fpWElzo3jK4bJQDq for <xfs@oss.sgi.com>;
	Fri, 14 Feb 2014 08:41:17 -0800 (PST)
Message-ID: <52FE472C.8070503@sandeen.net>
Date: Fri, 14 Feb 2014 10:41:16 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: test for atime-related mount options
References: <1392305016-7424-1-git-send-email-koen.de.wit@oracle.com>
	<52FCF60F.6030703@sandeen.net>
	<20140214163925.GW16073@twin.jikos.cz>
In-Reply-To: <20140214163925.GW16073@twin.jikos.cz>
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
To: dsterba@suse.cz, Koen De Wit <koen.de.wit@oracle.com>, xfs@oss.sgi.com, linux-btrfs@vger.kernel.org

On 2/14/14, 10:39 AM, David Sterba wrote:
> On Thu, Feb 13, 2014 at 10:42:55AM -0600, Eric Sandeen wrote:
>>> +cat /proc/mounts | grep "$SCRATCH_MNT" | grep relatime >> $seqres.full
>>> +[ $? -ne 0 ] && echo "The relatime mount option should be the default."
>>
>> Ok, I guess "relatime" in /proc/mounts is from core vfs code and
>> should be there for the foreseeable future, so seems ok.
>>
>> But - relatime was added in v2.6.20, and made default in 2.6.30.  So
>> testing older kernels may not go as expected; it'd probably be best to
>> catch situations where relatime isn't available (< 2.6.20) or not
>> default (< 2.6.30), by explicitly mounting with relatime, and skipping
>> relatime/strictatime tests if that fails?
> 
> Is there some consensus what's the lowest kernel version to be supported
> by xfstests? 2.6.32 is the lowest base for kernels in use today, so
> worrying about anything older does not seem necessary.
> 

I don't know that it's been discussed - selfishly, I know our QE uses
xfstests on RHEL5, which is 2.6.18-based.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
