Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAAGdk7C105859 for <xfs@oss.sgi.com>; Thu, 10 Nov 2011 10:39:47 -0600
Message-ID: <4EBBFE4E.6050900@sgi.com>
Date: Thu, 10 Nov 2011 10:39:42 -0600
From: Bill Kendall <wkendall@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsdump: handle Ctrl-D during prompts
References: <1320876946-27643-1-git-send-email-wkendall@sgi.com>
	<20111110083113.GA10573@infradead.org>
In-Reply-To: <20111110083113.GA10573@infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> On Wed, Nov 09, 2011 at 04:15:46PM -0600, Bill Kendall wrote:
>> xfsdump does not currently handle Ctrl-D well during a dialog
>> prompt. If some text is entered followed by Ctrl-D, an assert
>> will trip because xfsdump expects a new-line character at the
>> end of the user's input (or if asserts are disabled, the last
>> character the user entered will be dropped).
>>
>> If Ctrl-D is entered without entering any response, some dialog
>> callers (e.g., tree_subtree_inter()) will abort because they
>> receive an unexpected response code.
>>
>> This patch changes xfsdump to treat Ctrl-D as if the user hit
>> enter. User input (if any) will be passed back to the caller,
>> and a new line will be echoed to the terminal.
> 
> Shouldn't Ctrl+D cause us to ignore the input that was added
> before?  That's what I would expect from command line applications.

Ctrl-C will behave the way you describe.

I tried a some interactive programs (parted, python, sftp, bash,
xfs_db), and Ctrl-D seems to be ignored if there's already some input.
I'll rework the patch to behave this way unless I hear back from
you.

Thanks,
Bill

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
