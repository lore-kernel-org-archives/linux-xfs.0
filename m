Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:41952 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753210AbdAZU2Z (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 26 Jan 2017 15:28:25 -0500
Subject: Re: [PATCH v3] xfs: do not call xfs_buf_hash_destroy on a NULL pag
References: <20170120142642.21698-1-colin.king@canonical.com>
 <20170125190443.20929-1-billodo@redhat.com>
 <2be6ef17-9664-fdfc-49d0-eebca1b14be5@sandeen.net>
 <20170126185532.GA13375@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <3a16ed69-fb7c-da77-82de-bbeb29431ed0@sandeen.net>
Date: Thu, 26 Jan 2017 14:27:51 -0600
MIME-Version: 1.0
In-Reply-To: <20170126185532.GA13375@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Bill O'Donnell <billodo@redhat.com>
Cc: linux-xfs@vger.kernel.org, darrick.wong@oracle.com

On 1/26/17 12:55 PM, Bill O'Donnell wrote:
>>> @@ -242,8 +245,11 @@ xfs_initialize_perag(
>>>  out_unwind:
>>>  	xfs_buf_hash_destroy(pag);
>>>  	kmem_free(pag);
>>> -	for (; index > first_initialised; index--) {
>>> -		pag = radix_tree_delete(&mp->m_perag_tree, index);
>>> +out_unwind_pags:
>>> +	for (i = index; i >= first_initialised; i--) {
>>> +		pag = radix_tree_delete(&mp->m_perag_tree, (xfs_agnumber_t)i);
>> (don't make i an int if it's really supposed to be an xfs_agnumber_t,
>> which is unsigned)
> It might be wrong, but I used an int in order to handle the case where
> first_initialized==0, and a decrement of an unsigned would roll over
> instead of going negative (so i >= first_initialized would be true again).

Oh, urgh.  I see.

OTOH AG count is unsigned, so if you have index > 2147483648 AGs,
your "i >= first" will fail because i will be negative in /that/
comparison.

Ok, how about something like:

out_unwind_pags:
	/* start unwinding at previous index */
	index--;
        do {
                /* uninitialize pag at this index */
		index--;
        } while (index && index >= first_initialised);

-Eric

