Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 68C5529E03
	for <xfs@oss.sgi.com>; Wed, 18 Sep 2013 16:04:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5BB02304032
	for <xfs@oss.sgi.com>; Wed, 18 Sep 2013 14:04:45 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id cBUvMtoTKjcoODuk for <xfs@oss.sgi.com>;
	Wed, 18 Sep 2013 14:04:44 -0700 (PDT)
Message-ID: <523A156A.5040502@sandeen.net>
Date: Wed, 18 Sep 2013 16:04:42 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsprogs: initialize filetype for lost+found creation
References: <52388C61.1000001@sandeen.net> <523A135D.7030509@sgi.com>
In-Reply-To: <523A135D.7030509@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On 9/18/13 3:55 PM, Mark Tinguely wrote:
> On 09/17/13 12:07, Eric Sandeen wrote:
>> If we create lost+found make sure it's got the proper filetype.
>>
>> Signed-off-by: Eric Sandeen<sandeen@redhat.com>
>> ---
>>
>> (sorry, untested, not sure how to force creation when I can't use
>> xfs_db to craft a filesystem that needs lost+found)
> 
> The {lib}xfs_dir_lookup() doesn't use the field - just like extended attributes use xfs_names but it won't use the field entry, but it does not hurt to have it initialized to something.

Thanks for the review - just FWIW, I was thinking that it needs
to be initialized so that when created, it is created with the proper
type, rather than random stack noise.

It seems, though, that we're still missing bits in libxfs to actually
write the types to disk; I'll look into that.

Thanks,
-Eric

> Reviewed-by: Mark Tinguely <tinguely@sgi.com>
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
