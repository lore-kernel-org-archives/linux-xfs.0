Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DD6027F9C
	for <xfs@oss.sgi.com>; Wed,  2 Oct 2013 15:13:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7587CAC002
	for <xfs@oss.sgi.com>; Wed,  2 Oct 2013 13:13:04 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id JzAeD5nXQFaGnbKK for <xfs@oss.sgi.com>;
	Wed, 02 Oct 2013 13:13:03 -0700 (PDT)
Message-ID: <524C7E4D.60208@sandeen.net>
Date: Wed, 02 Oct 2013 15:13:01 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsrestore: fix multi stream support
References: <524AF8AE.5030300@sgi.com> <524C68C5.2030202@sandeen.net>
	<524C7BF6.5050107@sgi.com>
In-Reply-To: <524C7BF6.5050107@sgi.com>
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
To: Rich Johnston <rjohnston@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On 10/2/13 3:03 PM, Rich Johnston wrote:
> 
> 
> On 10/02/2013 01:41 PM, Eric Sandeen wrote:

...

>> What ,do you think?
> 
> Sure go for it. That was one of my test programs but obviously I
> choose the wrong one. ;) Its really sixes to me.
> 
> I still think the the check in partial_reg is not needed. I never saw
> a case where single stream restore hits that check except when there
> are no extents. Do you have an case/example?

I don't.  It seems like reasonable defensive programming, though,
so I'm not anxious to remove it, given that nobody really groks
this code too well.  Could turn it into a warning, maybe, so
it fires if we do ever get there.

Can you look back in ptools & see when/why it was added?

> We saw this issue with DMF offline files because DMF removes the
> extents and the file has an attribute which is not restored with the
> current code using multistream.

Ah, I think there's something about not restoring attributes until
all of the file has been restored.  So again in this case, the file
never looks "restored" and it never gets to the attribute restoration?

Oh right, like the comment says:

/* partial_reg - Registers files that are only partially restored by
 * a dump stream into the persistent state.
 *
 * This is done because DMAPI extended attributes must not be set until
 * the entire file has been restored in order to co-ordinate with the 
 * Data Migration Facility (DMF) daemons.  Since extended attributes are
 * recorded with each extent group in the dump, this registry is used to
 * make sure only the final dump stream applies the extended attributes.
 *
 * Likewise, certain extended inode flags (e.g. XFS_XFLAG_IMMUTABLE)
 * should only be set after all data for a file has been restored.
 */

> So I thinks a simple test case is:
> 
> Create a file with no extents. Give that file an attribute dump and
> restore it (both single and multistream) verify the file still has
> the attribute.

An extended attribute you mean?

> Your thoughts?

Yeah, go for it w/ a testcase. :)

I could see where even if we didn't get the dreaded "Out of records"
message, it might still skip the attribute restore if the file
never looks "done?"

-Eric

 --Rich
> 
>> 
>> -Eric
>> 
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
