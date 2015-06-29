Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F23137F5A
	for <xfs@oss.sgi.com>; Sun, 28 Jun 2015 20:18:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E10498F8035
	for <xfs@oss.sgi.com>; Sun, 28 Jun 2015 18:18:01 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 3pHLkG5LCMOpSqdD for <xfs@oss.sgi.com>;
	Sun, 28 Jun 2015 18:17:55 -0700 (PDT)
Message-ID: <55909CC1.2020301@sandeen.net>
Date: Sun, 28 Jun 2015 20:17:53 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Q: xfs_db: invalid numrecs (*) in bmapbtd block
References: <CAGqmi75jFGjWvFFT5HTwyO1tv4-d4J=aVJ83L2zqNyWMDOz1RQ@mail.gmail.com>
	<55907148.1050509@sandeen.net>
	<CAGqmi75V-DWbJR0LPOqwhg3s501G_kSDpcPjbPi6nuGWOJNrKA@mail.gmail.com>
In-Reply-To: <CAGqmi75V-DWbJR0LPOqwhg3s501G_kSDpcPjbPi6nuGWOJNrKA@mail.gmail.com>
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
To: Timofey Titovets <nefelim4ag@gmail.com>
Cc: xfs@oss.sgi.com

On 6/28/15 5:29 PM, Timofey Titovets wrote:
> 2015-06-29 1:12 GMT+03:00 Eric Sandeen <sandeen@sandeen.net>:

...

>> You're likely just seeing that inconsitency because you're reading
>> it while it's mounted; possibly even while it's being modified.
>>
>> -Eric
> 
> I already thinked about this case, and it seems incredible.
> 1. i can get consistent or very close to consistent fs, by run 'sync'
> 2. Okay, supposing you are right,
> then i must get different errors over time, because fs will change own
> state over time (also after every sync call).
> But its don't happen, i get same errors over long period of time (1
> day+, i think on busy FS server, its enoug to think what data on disk
> has changed)
> Also, i have several others server, and on it i didn't see this
> problem (over 2-3 month).
> 
> 
> Then I can conclude this is errors in FS, only what matter to me now,
> this type of errors can damage my data and i must move virtual
> machines from it ASAP, or i can continue working and this is just
> "artefact".
> 
> Fix me if i'm wrong.

Your other option is to unmount and run xfs_repair, and find out if
you actually have on-disk corruption.  It's the only way to know
for sure (or: freeze the fs, snapshot the device, and run repair on that)

-Eric

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
