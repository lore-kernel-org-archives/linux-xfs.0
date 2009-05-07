Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n472kJNK166383 for <xfs@oss.sgi.com>; Wed, 6 May 2009 21:46:20 -0500
Received: from millhouse.houseofnate.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 046191D15144
	for <xfs@oss.sgi.com>; Wed,  6 May 2009 19:46:22 -0700 (PDT)
Received: from millhouse.houseofnate.net
	(dsl092-086-237.bos1.dsl.speakeasy.net [66.92.86.237]) by
	cuda.sgi.com with ESMTP id PWUSbJn5Rwemjq0m for
	<xfs@oss.sgi.com>; Wed, 06 May 2009 19:46:22 -0700 (PDT)
Message-ID: <4A024B7C.4010409@houseofnate.net>
Date: Wed, 06 May 2009 22:46:20 -0400
From: "Nathaniel W. Turner" <nate@houseofnate.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_repair: open filesystem device exclusively
References: <49B48B8E.3030602@houseofnate.net>	<49B491EA.4090003@houseofnate.net>
	<20090316212332.GA8496@infradead.org>
In-Reply-To: <20090316212332.GA8496@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3014492648322656848=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This is a multi-part message in MIME format.
--===============3014492648322656848==
Content-Type: multipart/alternative;
 boundary="------------030107000307030706040705"

This is a multi-part message in MIME format.
--------------030107000307030706040705
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

...just a friendly reminder to look at this again now that 3.0.1 is out.

Christoph Hellwig wrote:
> On Sun, Mar 08, 2009 at 11:50:02PM -0400, Nathaniel W. Turner wrote:
>   
>> (Error messages could probably be improved to be more user-friendly in
>> this new failure case, and it probably wouldn't hurt to add a BLKROGET
>> ioctl to check for read-only block devices with read-write permissions,
>> but this does the job for me.)
>>
>> Signed-off-by: Nathaniel W. Turner <nate@houseofnate.net>
>> ---
>>  repair/init.c |    2 ++
>>  1 files changed, 2 insertions(+), 0 deletions(-)
>>
>> diff --git a/repair/init.c b/repair/init.c
>> index 8e508c4..7e5052c 100644
>> --- a/repair/init.c
>> +++ b/repair/init.c
>> @@ -142,6 +142,8 @@ xfs_init(libxfs_init_t *args)
>>          args->isreadonly = (LIBXFS_ISREADONLY | LIBXFS_ISINACTIVE);
>>      else if (dangerously)
>>          args->isreadonly = (LIBXFS_ISINACTIVE | LIBXFS_DANGEROUSLY);
>> +    else
>> +        args->isreadonly = LIBXFS_EXCLUSIVELY;
>>     
>
> Given that we skip it for -d and -n this is fine with me.
>
> I think we might want to delay this change in the way xfs_repair
> operates until after we get a 3.0.1 release out with all the build
> system fixes (hopefully really soon)
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>   

-- 
Nathaniel W. Turner
http://houseofnate.net/


--------------030107000307030706040705
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 7bit

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html;charset=UTF-8" http-equiv="Content-Type">
</head>
<body bgcolor="#ffffff" text="#000000">
...just a friendly reminder to look at this again now that 3.0.1 is out.<br>
<br>
Christoph Hellwig wrote:
<blockquote cite="mid:20090316212332.GA8496@infradead.org" type="cite">
  <pre wrap="">On Sun, Mar 08, 2009 at 11:50:02PM -0400, Nathaniel W. Turner wrote:
  </pre>
  <blockquote type="cite">
    <pre wrap="">(Error messages could probably be improved to be more user-friendly in
this new failure case, and it probably wouldn't hurt to add a BLKROGET
ioctl to check for read-only block devices with read-write permissions,
but this does the job for me.)

Signed-off-by: Nathaniel W. Turner <a class="moz-txt-link-rfc2396E" href="mailto:nate@houseofnate.net">&lt;nate@houseofnate.net&gt;</a>
---
 repair/init.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/repair/init.c b/repair/init.c
index 8e508c4..7e5052c 100644
--- a/repair/init.c
+++ b/repair/init.c
@@ -142,6 +142,8 @@ xfs_init(libxfs_init_t *args)
         args-&gt;isreadonly = (LIBXFS_ISREADONLY | LIBXFS_ISINACTIVE);
     else if (dangerously)
         args-&gt;isreadonly = (LIBXFS_ISINACTIVE | LIBXFS_DANGEROUSLY);
+    else
+        args-&gt;isreadonly = LIBXFS_EXCLUSIVELY;
    </pre>
  </blockquote>
  <pre wrap=""><!---->
Given that we skip it for -d and -n this is fine with me.

I think we might want to delay this change in the way xfs_repair
operates until after we get a 3.0.1 release out with all the build
system fixes (hopefully really soon)

_______________________________________________
xfs mailing list
<a class="moz-txt-link-abbreviated" href="mailto:xfs@oss.sgi.com">xfs@oss.sgi.com</a>
<a class="moz-txt-link-freetext" href="http://oss.sgi.com/mailman/listinfo/xfs">http://oss.sgi.com/mailman/listinfo/xfs</a>
  </pre>
</blockquote>
<br>
<pre class="moz-signature" cols="72">-- 
Nathaniel W. Turner
<a class="moz-txt-link-freetext" href="http://houseofnate.net/">http://houseofnate.net/</a>
</pre>
</body>
</html>

--------------030107000307030706040705--


--===============3014492648322656848==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3014492648322656848==--
