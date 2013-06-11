Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9430029DF8
	for <xfs@oss.sgi.com>; Tue, 11 Jun 2013 13:03:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0E20EAC005
	for <xfs@oss.sgi.com>; Tue, 11 Jun 2013 11:03:20 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id ewjbvVRe6OOEQ3Uw for <xfs@oss.sgi.com>;
	Tue, 11 Jun 2013 11:03:19 -0700 (PDT)
Message-ID: <51B76666.1020900@sandeen.net>
Date: Tue, 11 Jun 2013 13:03:18 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Questions about XFS
References: <loom.20130611T112155-970@post.gmane.org>
	<51B72D3D.5010206@redhat.com>
	<CAO9HMNGjdikgX+_434aGVJ2NAJ0hxDNLo+Vsa46GH3psXr4sKQ@mail.gmail.com>
	<51B75C39.3030306@redhat.com>
	<CAAxjCEyne63XH1Uk6_7jzjaxDbsSopO9E+=6oo3xE=PvjBFcjA@mail.gmail.com>
	<51B75EF7.40801@redhat.com>
	<CAAxjCEwvudBHV1LAEKOabTBk7no4uXV8RbfZDbm5E=TjA_Vm5A@mail.gmail.com>
In-Reply-To: <CAAxjCEwvudBHV1LAEKOabTBk7no4uXV8RbfZDbm5E=TjA_Vm5A@mail.gmail.com>
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
To: Stefan Ring <stefanrin@gmail.com>
Cc: Steve Bergman <sbergman27@gmail.com>, Ric Wheeler <rwheeler@redhat.com>, Linux fs XFS <xfs@oss.sgi.com>

On 6/11/13 12:41 PM, Stefan Ring wrote:
>>> Every database software will do the flushing correctly.
>>
>>
>> Stefan, you are making my point because every database will do the right
>> thing, it won't rely on ext3's magic every 5 second fsync :)
> 
> Ok, let us agree on this one then ;)
> 
> There is still kind of a dichotomy regarding the entire issue. While
> in many cases, noone will complain about a few  seconds of lost data,
> it is an entirely different beast if you lose an entire file that may
> have been added to and maintained over month/years, just because the
> system went down at an unfortunate moment. In my opinion, having a
> consistent, yet possibly somewhat outdated file, is much more
> important than having the most recent view in an inconsistent/broken
> state.

But the application needs to watch out for that too.  Appending to, or
overwriting part of a file, should never result in whole-file loss on a crash,
although it may lead to data inconsistency.  If you truncate the file and rewrite,
there is more risk.

If you want atomic updates so that you get either-old-or-new-version,
that can be accomplished.

>From the LWN article we keep linking to ;)

Similarly, if you encounter a system failure (such as power loss, ENOSPC or an I/O error) while overwriting a file, it can result in the loss of existing data. To avoid this problem, it is common practice (and advisable) to write the updated data to a temporary file, ensure that it is safe on stable storage, then rename the temporary file to the original file name (thus replacing the contents). This ensures an atomic update of the file, so that other readers get one copy of the data or another. The following steps are required to perform this type of update:

    create a new temp file (on the same file system!)
    write data to the temp file
    fsync() the temp file
    rename the temp file to the appropriate name
    fsync() the containing directory 

-Eric


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
