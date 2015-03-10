Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 655C07F3F
	for <xfs@oss.sgi.com>; Tue, 10 Mar 2015 10:43:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 44D95304048
	for <xfs@oss.sgi.com>; Tue, 10 Mar 2015 08:43:46 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 0nsCUkQYBkmDYSf6 for <xfs@oss.sgi.com>;
	Tue, 10 Mar 2015 08:43:42 -0700 (PDT)
Message-ID: <54FF112C.7040706@sandeen.net>
Date: Tue, 10 Mar 2015 11:43:40 -0400
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_repair: junk last entry in sf dir if name starts
	beyond dir size
References: <54FDFEDC.5090106@sandeen.net>	<20150310011745.GA2722@laptop.bfoster>
	<54FEF12A.8090507@sandeen.net>
In-Reply-To: <54FEF12A.8090507@sandeen.net>
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
To: Brian Foster <bfoster@redhat.com>
Cc: Rui Gomes <rgomes@rvx.is>, xfs-oss <xfs@oss.sgi.com>

On 3/10/15 9:27 AM, Eric Sandeen wrote:
> On 3/9/15 9:17 PM, Brian Foster wrote:
>> On Mon, Mar 09, 2015 at 04:13:16PM -0400, Eric Sandeen wrote:
>>> When process_sf_dir2() is trying to salvage entries in a corrupted
>>> short form directory, it may attempt to shorten the last entry in
>>> the dir if it extends beyond the directory size.
>>>
>>> However, if the name already starts past the dir size, no amount
>>> of name-shortening will make it fit, but the code doesn't realize
>>> this.  The namelen variable comes out to be negative, and things
>>> go downhill from there, resulting in a segfault when we try to
>>> memmove a negative number of bytes.
>>>
>>> If no amount of name-shortening can make the last dir entry fit
>>> in the dir size, simply junk the entry.
>>>
>>> Reported by: Rui Gomes <rgomes@rvx.is>
>>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>>> ---
>>>
>>> This adds a bit more spaghetti to an existing pot, but I think
>>> it clearly fixes the problem; I might try to rework these cases
>>> to coalesce some of the code.
>>>
>>> (I also wonder about the tradeoff between shortening entries and
>>> increasing the dir size, but for now I'm just following the
>>> direction the repair code already takes).
>>>
>>
>> Seems Ok on a first glance. The fix is associated with the specific
>> namelen calculation. Are we susceptible to a similar problem in the
>> previous branch where we also calculate namelen from the dir size (the
>> namelen == 0 case)? It looks like we could set a bad value there.
> 
> Hum, yes, I guess so ("namelen == 0" kind of threw me off).
> 
> I'll see how to handle that w/o more cut & paste.

Hohum, another related bug in this code is that it isn't handling
dir3; this whole business of adjusting namelen to match end of dir
doesn't take into account that with dir3, a file type and an inode
number follow the name.

So for example when fixing a 0-length entry, it does:

> entry "" in shortform directory 67 references invalid inode 1650614882
> entry #1 is zero length in shortform dir 67, resetting to 29
> entry contains illegal character in shortform dir 67
> junking entry "bbbbbbbbbbbbbbbbbbbbbbbb" in directory inode 67

where the actual entry length should be 24, and I think the rest is
filetype etc; this is why it thought there were bogus chars and
ended up junking it all.

Something else to fix...

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
