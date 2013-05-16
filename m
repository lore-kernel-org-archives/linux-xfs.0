Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 734DC7F37
	for <xfs@oss.sgi.com>; Thu, 16 May 2013 10:49:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 522C28F8064
	for <xfs@oss.sgi.com>; Thu, 16 May 2013 08:49:34 -0700 (PDT)
Received: from exprod7og106.obsmtp.com (exprod7og106.obsmtp.com [64.18.2.165])
	by cuda.sgi.com with SMTP id 3vMIlzSLWGQ9dBmN (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 16 May 2013 08:49:31 -0700 (PDT)
Message-ID: <5194FEF9.6040802@genband.com>
Date: Thu, 16 May 2013 09:44:57 -0600
From: Chris Friesen <chris.friesen@genband.com>
MIME-Version: 1.0
Subject: Re: any way to work backwards from xfs_inode_t to a filename?
References: <5194050B.7010401@genband.com> <20130515221000.GX812@sgi.com>
	<51940A08.2040306@sandeen.net> <20130515230459.GY812@sgi.com>
In-Reply-To: <20130515230459.GY812@sgi.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Ben Myers <bpm@sgi.com>
Cc: Alex Elder <elder@kernel.org>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On 05/15/2013 05:04 PM, Ben Myers wrote:
> Chris,
>
> On Wed, May 15, 2013 at 05:19:52PM -0500, Eric Sandeen wrote:
>> On 5/15/13 5:10 PM, Ben Myers wrote:
>>>> 1) do_unlinkat() has the filesystem path, but iput() returns void.
>>>> Is there any way for me to add instrumentation to xfs_inactive() to
>>>> work backwards from the xfs_inode_t pointer to print out a path to
>>>> the file being deleted?
>>>
>>> Use VFS_I to get to a 'struct inode' and from there you can look at the
>>> dentries on i_dentry list and traverse back through the path by looking at
>>> d_parent.  Might be easier to just print the path in do_unlinkat?
>>
>> or just print out the inode nr (i_ino) and do a find -inum after the fact.  :)
>
> +1
>
> Dave pointed out that you might not be able to get to the inode at this point
> in the lifecycle.  Apologies if I posted misinformation.  ;)

Thanks guys,

I'm headed away for a few days so it'll be a while before I can dig into 
this again, but this should give me a good start.

Chris

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
