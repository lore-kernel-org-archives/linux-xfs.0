Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46C1CC433E0
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Jan 2021 00:05:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E82C2255F
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Jan 2021 00:05:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbhAEAFg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Jan 2021 19:05:36 -0500
Received: from ishtar.tlinx.org ([173.164.175.65]:50792 "EHLO
        Ishtar.sc.tlinx.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726163AbhAEAFg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Jan 2021 19:05:36 -0500
Received: from [192.168.3.12] (Athenae [192.168.3.12])
        by Ishtar.sc.tlinx.org (8.14.7/8.14.4/SuSE Linux 0.8) with ESMTP id 10504ieV071258;
        Mon, 4 Jan 2021 16:04:46 -0800
Message-ID: <5FF3ACCB.3030909@tlinx.org>
Date:   Mon, 04 Jan 2021 16:03:23 -0800
From:   L A Walsh <xfs@tlinx.org>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
CC:     bfoster@redhat.com, xfs <linux-xfs@vger.kernel.org>
Subject: Re: suggested patch to allow user to access their own file...
References: <5FEB204B.9090109@tlinx.org> <20210104170815.GB254939@bfoster> <20210104184442.GM6918@magnolia> <5FF3796E.5050409@tlinx.org> <20210104231508.GP6918@magnolia>
In-Reply-To: <20210104231508.GP6918@magnolia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2021/01/04 15:15, Darrick J. Wong wrote:
>> Cc: bfoster@redhat.com, xfs-oss <xfs@e29208.dscx.akamaiedge.net>
> 
> akamaiedge.net ??
---
First I've seen that...

> 
> Er, did my mailer do that, or did yours?
> 
> [re-adding linux-xfs to cc]
> 
> On Mon, Jan 04, 2021 at 12:24:14PM -0800, L A Walsh wrote:
>>
>> On 2021/01/04 10:44, Darrick J. Wong wrote:
>>> This would open a huge security hole because users can use it to bypass
>>> directory access checks.
>> ---
>> 	Can't say I entirely disagree.  Though given the prevalence of that
>> behavior being "normal" on NT due to the "Bypass Traverse Checking" "right"
>> being on by default in a standard Windows setup,
> 
> That might be true on Windows, but CAP_DAC_* isn't given out by default
> on Linux.
----
	Not quite the same as I understand it -- it allows ignoring 
an 'X' permission of directories above the target, I believe, but not other
DAC permissions.  I'd have to experiment to be sure.  In their security
settings dialogue, they warn you against changing it away from the default
as it might cause compatibility problems.


> 
>> I would question it being a 'huge' security hole, though it would be
>> an unwanted change in behavior.
> 
> I think people would consider it a hole of /some/ kind, since this patch
> wouldn't even require the process to hold CAP_DAC_* privilege.
---
	Yeah, though it doesn't allow overriding DAC settings on files
or directories that have them when trying to access them, just bypassing
directory traversal permissions for items lower in the hierarchy.


> 
> Yeah.  As far as I can tell, CAP_DAC_OVERRIDE actually /does/ give you
> the security permissions that you want.  The sysadmin can then decide
> who gets to have that permission, so you /could/ propose doing that.
----
	Except that it does more than just allowing directory traversal
to a set of files you own.  Like I think it might not be uncommon to have
some common home dir set restrictively, so you couldn't read who else had
home directories on the system, perhaps, but you could still cd through
it to your own directory.  It may be more like allowing you to 'x' through
parent directories without being able to read/write to them.  CAP_DAC_OVERRIDE
would allow you to override any DAC permissions on any file -- not just
ignore lack of 'X' on a directory.


> 
>> 	If it isn't possible already, I'm sure it soon will be
>> the case that users will be on systems that have different file
>> systems mounted.  If an xfs file system is mounted under an NT
>> file system and the user is running Windows, wouldn't NT-rights
>> (like ignoring traversal issues) apply by default, as NT would
>> be in charge of enforcing security as it walked through a locally
>> mounted XFS file system?
> 
> When would NT be walking through a locally mounted XFS filesystem?
 
Well, at least when it is mounted in a linux subsystem -- I haven't checked
out what's possible, but am told explorer can then be used to move through 
file systems that are locally mounted through the linux drivers.

The other possibility -- is a stretch of locally mounted, in having
an XFS drive mounted via CIFS as a "local" drive.  I'd think it would
allow bypassing traverse checking in the same way that having
NT-admin privileges can give you root access to exported drives, but
you have to set it up so that your login has those privs on the target server,
but less drastic privs, like bypassing traverse checking and having
a read/write access for a user that has the backup+restore privs are likely
also supported.  

As an example, a Domain administrator on my NT workstation has root access
to my server (not by accident, but because it is meant to be that way).

I use Win as a desktop, but lin as my diskspace+server.  My Win desktop barely
has enough diskspace for the OS + programs I have installed.
