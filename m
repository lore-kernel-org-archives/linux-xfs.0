Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:46138 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726964AbeK2Ktx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 29 Nov 2018 05:49:53 -0500
Subject: Re: [PATCH 1/6] xfs_io.8: rearrange command listings by section
References: <154181071499.3727.3910572718199592407.stgit@magnolia>
 <154181072098.3727.12783001969841425328.stgit@magnolia>
 <8c568cb2-4931-288c-0be3-68bd5caef634@sandeen.net>
 <20181128233459.GD8131@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <65174e05-0c7e-f524-3bce-25d59ea5773f@sandeen.net>
Date: Wed, 28 Nov 2018 17:46:31 -0600
MIME-Version: 1.0
In-Reply-To: <20181128233459.GD8131@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org



On 11/28/18 5:34 PM, Darrick J. Wong wrote:
> On Wed, Nov 28, 2018 at 04:39:47PM -0600, Eric Sandeen wrote:
>> On 11/9/18 6:45 PM, Darrick J. Wong wrote:
>>> From: Darrick J. Wong <darrick.wong@oracle.com>
>>>
>>> Most of the commands listed under "OTHER COMMANDS" apply to files or
>>> filesystems.  Create two new sections for that and populate them
>>> appropriately.
>>>
>>> Here's what moves:
>>>
>>> fsmap: moves from file io commands to filesystem commands
>>> utimes: moves from file io commands to file commands
>>>
>>> >From the OTHER COMMANDS section:
>>>
>>> lsattr/chattr: moves to file commands
>>> flink: moves to file commands
>>> stat/statx: moves to file commands
>>> lsproj/chproj: moves to file commands
>>> parent: moves to file commands
>>> [gs]et_encpolicy: moves to file io commands
>>> freeze/thaw: move to filesystem commands
>>> inject: move to filesystem commands
>>> resblks: move to filesystem commands
>>> shutdown: move to filesystem commands
>>> statfs: move to filesystem commands
>>> label: move to filesystem commands
>>
>> Thank you for getting this better organized.  Of course, I have
>> some questions.  :)
>>
>> What does "FILE COMMANDS" vs. "FILE I/O COMMANDS" mean, exactly?
>> I ask because for example bmap & fiemap are still under FILE IO but
>> they... really don't do file IO.  What's your intended distinction
>> with these new sections?
> 
> Admittedly, it's been a looong time since I wrote this patch.

yeah, that's my fault, sorry.

> Um... I think my intent was for FILE COMMANDS to pertain to file
> attributes, whereas FILE I/O COMMANDS would pertain to reading, writing,
> encoding, mapping, and otherwise messing with the contents of a file.

Because the distinction requires a fair bit of explanation I think it'd be
better to just lump them all into FILE OPERATIONS i.e. "these operate
on individual files not the filesystem in general."

Explicitly re-categorizing into rather vague categories doesn't seem
overly helpful.  :)

-Eric
