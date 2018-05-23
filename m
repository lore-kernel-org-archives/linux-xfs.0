Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:47176 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934235AbeEWWDG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 23 May 2018 18:03:06 -0400
Subject: Re: [PATCH v3] xfs_io: Allow -P and -L to be given to open for O_PATH
 and O_NOFOLLOW
From: Eric Sandeen <sandeen@sandeen.net>
References: <20180516132738.27776-1-jlayton@kernel.org>
 <20180516171428.25576-1-jlayton@kernel.org>
 <7a2485bc-de36-e3c5-58ab-4023b965c6c5@sandeen.net>
Message-ID: <f801db6e-6ce3-a79f-3458-6b99c8622c1a@sandeen.net>
Date: Wed, 23 May 2018 17:03:05 -0500
MIME-Version: 1.0
In-Reply-To: <7a2485bc-de36-e3c5-58ab-4023b965c6c5@sandeen.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jeff Layton <jlayton@kernel.org>
Cc: linux-xfs@vger.kernel.org, dhowells@redhat.com



On 5/23/18 4:51 PM, Eric Sandeen wrote:
> On 5/16/18 12:14 PM, Jeff Layton wrote:
>> From: David Howells <dhowells@redhat.com>
>>
>> Allow "open -P" to specify O_PATH so that paths which would otherwise be
>> unopenable might be opened for stat()'ing.  Such things include files that
>> would incur an access error or device files for which no corresponding
>> driver is available.
>>
>> Allow "-L" to be given in conjunction with O_PATH to specify O_NOFOLLOW
>> also.
>>
>> We also have to avoid calling xfsctl() if O_PATH is given as ioctls are
>> forbidden on such fds.  This means we cannot retrieve the geometry
>> information on an XFS filesystem, so the record gets cleared instead.  For
>> the moment, only the xfsctl() calls in the 'open' command are
>> conditionalised.
>>
>> Signed-off-by: David Howells <dhowells@redhat.com>
>> Signed-off-by: Jeff Layton <jlayton@redhat.com>
> 
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>

hm actually I'll need to locally define O_PATH so it builds on older
systems:

+#ifndef O_PATH
+#if defined __alpha__
+#define O_PATH          040000000
+#elif defined(__hppa__)
+#define O_PATH          020000000
+#elif defined(__sparc__)
+#define O_PATH          0x1000000
+#else
+#define O_PATH          010000000
+#endif
+#endif /* O_PATH */

... like we do for O_TMPFILE.  I can do that on the way in.

-Eric
