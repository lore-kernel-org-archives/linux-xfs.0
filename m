Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 96B8529DF7
	for <xfs@oss.sgi.com>; Fri, 28 Nov 2014 10:40:11 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 83F1B8F8052
	for <xfs@oss.sgi.com>; Fri, 28 Nov 2014 08:40:11 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id BqLTDUkgJdyruavj for <xfs@oss.sgi.com>;
	Fri, 28 Nov 2014 08:40:09 -0800 (PST)
Message-ID: <5478A566.2080500@sandeen.net>
Date: Fri, 28 Nov 2014 10:40:06 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: no quota output if no usage?
References: <5476297F.8080304@sandeen.net>
	<20141126212144.GD9561@dastard>	<54764582.6000005@sandeen.net>
	<20141126221845.GE9561@dastard>	<54767030.7070706@sandeen.net>
	<20141127093225.GB30152@quack.suse.cz>
In-Reply-To: <20141127093225.GB30152@quack.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: xfs-oss <xfs@oss.sgi.com>

On 11/27/14 3:32 AM, Jan Kara wrote:
> On Wed 26-11-14 18:28:32, Eric Sandeen wrote:
>> On 11/26/14 4:18 PM, Dave Chinner wrote:
>>
>>>> Or am I missing something ...
>>>
>>> Nope, I'm confusing different reporting command behaviour....
>>
>> Ok, so back to the original question: think it's cool to drop
>> the verbose requirement to find out limits when there is 0 usage?
>   Just as a data point quota(1) command from quota-tools also doesn't
> report quota entries where no space & inode is accounted without -v option.
> I never thought it's particularly useful but apparently it's some heritage
> from the original implementation of quota in some Unix and so I decided to
> maintain compatibility...

Thanks - sounds like maybe the weight of history is behind this.  Perhaps
it'll just be a documentation fix to clarify what happens when there's no
block or inode used.

-Eric

> 								Honza
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
